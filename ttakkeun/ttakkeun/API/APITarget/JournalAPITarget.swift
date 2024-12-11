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
    
    /* 일지 삭세 */
    case deleteJournal(recordId: Int)
    
    /* 일지 기록 검색 */
    case searchGetJournal(category: PartItem.RawValue, page: Int, date: String)
    
    /* 진단 생성 */
    case makeDiagnosis(data: CreateDiagRequst)
    
    /* 진단 생성 후, 추천 제품 네이버 쇼핑 정보로 업데이트*/
    case updateNaverDiag(data: DiagResultResponse)
    
    case getDiagResult(diagId: Int)
}

extension JournalAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getJournalList(let petId, let category, _):
            return "/api/record/\(petId)/\(category)"
        case .getDetailJournalData(let petId, let recordId):
            return "/api/record/detail/\(petId)/\(recordId)"
        case .makeJournal(_, _, _):
            return "/api/record/create/\(UserState.shared.getPetId())"
        case .getAnswerList(let category):
            return "/api/record/register/\(category)"
        case .deleteJournal(let recordId):
            return "/api/record/\(recordId)"
        case .searchGetJournal(let category, _, _):
            return "/api/record/search/\(UserState.shared.getPetId())/\(category)"
        case .makeDiagnosis:
            return "/api/diagnose/loading"
        case .updateNaverDiag(let data):
            return "/api/diagnose/result/\(data.result_id)"
        case .getDiagResult(let diagId):
            return "/api/diagnose/result/\(diagId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getJournalList, .getDetailJournalData, .getAnswerList, .searchGetJournal, .getDiagResult:
            return .get
        case .makeJournal, .makeDiagnosis:
            return .post
        case .deleteJournal:
            return .delete
        case .updateNaverDiag:
            return .patch
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
        case .deleteJournal:
            return .requestPlain
        case .searchGetJournal(_, let page, let date):
            return .requestParameters(parameters: ["page": page, "date": date], encoding: URLEncoding.default)
        case .makeDiagnosis(let data):
            return .requestJSONEncodable(data)
        case .updateNaverDiag(let data):
            return .requestParameters(parameters: ["products": data.products], encoding: JSONEncoding.default)
        case .getDiagResult:
            return .requestPlain
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

private func encodeRegistJournalData(category: String, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> [MultipartFormData] {
    var formData: [MultipartFormData] = []
    
    // 카테고리 추가
    let categoryData = MultipartFormData(provider: .data(category.data(using: .utf8)!), name: "category")
    formData.append(categoryData)
    print("🔵 Category Data: \(category)")
    
    // 답변 추가
    for (index, (questionId, answers)) in data.answers.enumerated() {
        // questionId 추가
        let questionIdData = MultipartFormData(provider: .data("\(questionId)".data(using: .utf8)!), name: "answers[\(index)].questionId")
        formData.append(questionIdData)
        print("🔵 answers[\(index)].questionId: \(questionId)")
        
        // answerText 추가
        for answer in answers {
            let answersData = MultipartFormData(provider: .data(answer.data(using: .utf8)!), name: "answers[\(index)].answerText")
            formData.append(answersData)
            print("🔵 answers[\(index)].answerText: \(answer)")
        }
        
        // 이미지 추가 (이미지가 있는 경우만 추가)
        if let images = questionImage[questionId], !images.isEmpty {
            for (imageIndex, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let imageMultiPartData = MultipartFormData(
                        provider: .data(imageData),
                        name: "answers[\(index)].images",
                        fileName: "image\(index)_\(imageIndex).jpg",
                        mimeType: "image/jpeg"
                    )
                    formData.append(imageMultiPartData)
                    print("🔵 Uploaded Image: answers[\(index)].images -> image\(index)_\(imageIndex).jpg")
                }
            }
        } else {
            let emptyFileData = MultipartFormData(provider: .data(Data()), name: "answers[\(index)].images", fileName: "", mimeType: "application/octet-stream")
            formData.append(emptyFileData)
            print("⚠️ No images for questionId: \(questionId), added empty file field")
        }
    }
    
    // 기타 정보 추가
    if let etcText = data.etc {
        let etcData = MultipartFormData(provider: .data(etcText.data(using: .utf8)!), name: "etc")
        formData.append(etcData)
        print("🔵 Etc: \(etcText)")
    }
    
    print("✅ FormData Prepared: \(formData.count) parts")
    return formData
}
