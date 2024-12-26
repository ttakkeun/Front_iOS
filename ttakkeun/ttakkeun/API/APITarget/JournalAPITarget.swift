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
    
    /* --- 일지 --- */
    
    case getJournalList(petId: Int, category: PartItem.RawValue, page: Int) // 일지 목록 조회
    case getDetailJournalData(petId: Int, recordId: Int) // 일지 상세 내용 조회
    case makeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) // 일지 생성
    case getAnswerList(category: PartItem.RawValue) // 일지 질문 및 답변 조회
    case deleteJournal(recordId: Int) // 일지 삭제
    case searchGetJournal(category: PartItem.RawValue, date: String) //일지 기록 검색
    
    /* --- 진단 --- */
    
    case makeDiagnosis(data: CreateDiagRequst) // AI 진단하기
    case updateNaverDiag(data: DiagResultResponse) // 추천 제품 네이버 쇼핑 정보로 업데이트
    case getDiagResult(diagId: Int) // 진단서 상세 내용 조회
    case getDiagList(petId: Int, category: PartItem.RawValue, page: Int)
    case getUserPoint
    case patchUserPoint
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
        case .searchGetJournal(let category, _):
            return "/api/record/search/\(UserState.shared.getPetId())/\(category)"
        case .makeDiagnosis:
            return "/api/diagnose/loading"
        case .updateNaverDiag(let data):
            return "/api/diagnose/result/\(data.result_id)"
        case .getDiagResult(let diagId):
            return "/api/diagnose/result/\(diagId)"
        case .getDiagList(let petId, let category, let page):
            return "/api/diagnose/\(petId)/\(category)/\(page)"
        case .getUserPoint:
            return "/api/diagnose/point"
        case .patchUserPoint:
            return "/api/diagnose/loading"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getJournalList, .getDetailJournalData, .getAnswerList, .searchGetJournal, .getDiagResult, .getDiagList, .getUserPoint:
            return .get
        case .makeJournal, .makeDiagnosis:
            return .post
        case .deleteJournal:
            return .delete
        case .updateNaverDiag, .patchUserPoint:
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
        case .searchGetJournal(_, let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.default)
        case .makeDiagnosis(let data):
            return .requestJSONEncodable(data)
        case .updateNaverDiag(let data):
            return .requestParameters(parameters: ["products": data.products], encoding: JSONEncoding.default)
        case .getDiagResult:
            return .requestPlain
        case .getDiagList:
            return .requestPlain
        case .getUserPoint:
            return .requestPlain
        case .patchUserPoint:
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
