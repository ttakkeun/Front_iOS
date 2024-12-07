//
//  JournalAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import Moya
import SwiftUI

enum JournalAPITarget {
    case getJournalList(petId: Int, category: PartItem.RawValue, page: Int)
    case getDetailJournalData(petId: Int, recordId: Int)
    
    /* 일지 생성 및 답변 조회 */
    case makeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]])
    case getAnswerList(category: PartItem.RawValue)
}

extension JournalAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getJournalList(let petId, let category, _):
            return "/api/record/\(petId)/\(category)"
        case .getDetailJournalData(let petId, let recordId):
            return "/api/record/detail/\(petId)/\(recordId)"
        case .makeJournal(_, let data, _):
            return "/api/record/create/\(data)"
        case .getAnswerList(let category):
            return "/api/record/register/\(category)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getJournalList, .getDetailJournalData, .getAnswerList:
            return .get
        case .makeJournal:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getJournalList(_, _, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .getDetailJournalData, .getAnswerList:
            return .requestPlain
        case .makeJournal(let category, let data, let questionImage):
            let formData = encodeRegistJournalData(category: category, data: data, questionImage: questionImage)
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .makeJournal:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

extension JournalAPITarget {
    private func encodeRegistJournalData(category: String, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> [MultipartFormData] {
        var formData: [MultipartFormData] = []
        
        // 카테고리 추가
        let categoryData = MultipartFormData(provider: .data(category.data(using: .utf8)!), name: "category")
        formData.append(categoryData)
        
        // 답변 추가
        for (questionId, answers) in data.answers {
            let questionIdData = MultipartFormData(provider: .data("\(questionId)".data(using: .utf8)!), name: "answers[\(questionId)].questionId")
            formData.append(questionIdData)
            
            for answer in answers {
                let answersData = MultipartFormData(provider: .data(answer.data(using: .utf8)!), name: "answers[\(questionId)].answerText")
                formData.append(answersData)
            }
            
            if let images = questionImage[questionId] {
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        let imageMultiPartData = MultipartFormData(
                            provider: .data(imageData),
                            name: "answers[\(questionId)].images",
                            fileName: "image\(questionId)_\(index).jpg",
                            mimeType: "image/jpeg"
                            )
                        formData.append(imageMultiPartData)
                    }
                }
            }
        }
        
        // 기타 정보 추가
        if let etcText = data.etc {
            let etcData = MultipartFormData(provider: .data(etcText.data(using: .utf8)!), name: "etc")
            formData.append(etcData)
        }
        
        return formData
    }
}
