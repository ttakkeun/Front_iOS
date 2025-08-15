//
//  JournalAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import Moya

enum RecordRouter {
    /// 일지 생성
    case postGenerateJournal(petId: Int, category: PartItem.RawValue, data: RecordGenerateRequest, questionImage: [Int: [Data]])
    /// 일지 목록 조회
    case getJournalList(petId: Int, category: PartItem.RawValue, page: Int)
    /// 일지 기록 검색
    case getSearchJournal(petId: Int, category: PartItem.RawValue, date: String)
    /// 일지 질문 및 답변 조회
    case getAnswerList(category: PartItem.RawValue)
    /// 일지 상세 내용 조회
    case getDetailJournalData(petId: Int, recordId: Int)
    /// 일지 삭제
    case deleteJournal(recordId: Int)
}

extension RecordRouter: APITargetType {
    
    var path: String {
        switch self {
        case .postGenerateJournal(let petId, _, _, _):
            return "/api/record/create/\(petId)"
        case .getJournalList(let petId, let category, _):
            return "/api/record/\(petId)/\(category)"
        case .getSearchJournal(let petId, let category, _):
            return "/api/record/search/\(petId)/\(category)"
        case .getAnswerList(let category):
            return "/api/record/register/\(category)"
        case .getDetailJournalData(let petId, let recordId):
            return "/api/record/detail/\(petId)/\(recordId)"
        case .deleteJournal(let recordId):
            return "/api/record/\(recordId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postGenerateJournal:
            return .post
        case .deleteJournal:
            return .delete
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postGenerateJournal(_, let category, let data, let questionImage):
            let formData = encodeRegistJournalData(category: category, data: data, questionImageData: questionImage)
            return .uploadMultipart(formData)
        case .getJournalList(_, _, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .getSearchJournal(_, _, let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postGenerateJournal:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

extension RecordRouter {
    private func encodeRegistJournalData(
        category: String,
        data: RecordGenerateRequest,
        questionImageData: [Int: [Data]]
    ) -> [MultipartFormData] {
        
        var formData: [MultipartFormData] = []

        func utf8Data(_ string: String) -> Data {
            string.data(using: .utf8) ?? Data()
        }

        func appendTextField(name: String, value: String) {
            formData.append(.init(provider: .data(utf8Data(value)), name: name))
        }

        func appendImageField(name: String, data: Data, fileName: String) {
            formData.append(.init(provider: .data(data), name: name, fileName: fileName, mimeType: "image/jpeg"))
        }

        func appendEmptyImageField(name: String) {
            formData.append(.init(provider: .data(Data()), name: name, fileName: "", mimeType: "application/octet-stream"))
        }

        // 1. 카테고리
        appendTextField(name: "category", value: category)

        // 2. 답변 및 이미지
        for (index, (questionId, answers)) in data.answers.enumerated() {
            appendTextField(name: "answers[\(index)].questionId", value: "\(questionId)")
            
            for answer in answers {
                appendTextField(name: "answers[\(index)].answerText", value: answer)
            }

            let imageKey = "answers[\(index)].images"
            if let images = questionImageData[questionId], !images.isEmpty {
                for (imageIndex, imageData) in images.enumerated() {
                    appendImageField(name: imageKey, data: imageData, fileName: "image\(index)_\(imageIndex).jpg")
                }
            } else {
                appendEmptyImageField(name: imageKey)
            }
        }

        // 3. 기타 정보
        if let etc = data.etc {
            appendTextField(name: "etc", value: etc)
        }

        return formData
    }
}

/*
 
 사용 방식
 let imageDataDict: [Int: [Data]] = uiImageDict.mapValues { images in
     images.compactMap { $0.jpegData(compressionQuality: 0.8) }
 }

 let formData = encodeRegistJournalData(category: "ear", data: request, questionImageData: imageDataDict)
 
 */
