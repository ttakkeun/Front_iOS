//
//  JournalAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation
import Moya
import SwiftUI

///일지 작성 API 타겟
enum JournalAPITarget {
    case getJournalList(petID: Int, category: PartItem.RawValue, page: Int) /* 일지 목록 조회 */
    case getJournalQuestions(category: PartItem.RawValue) /* 일지 질문 조회 */
    case registJournal(data: RegistJournalData, category: PartItem.RawValue) /* 일지 등록 */
    case deleteJournalList(journalID: Int) /* 일지 삭제 */
    case getDetailJournalQnA(petId:Int, recordId: Int) /* 일지 디테일 조회 */
    case sendRecordImage(recordID: Int, questionImages: [Int: [UIImage]])
    case makeDiagnosis(data: CreateDiag)
    case updateContents(resultId: Int, query: [String])
    case getResultDiag(resultId: Int)
}

extension JournalAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getJournalList(let petID, let category, _):
            return "/record/\(petID)/\(category)"
        case .getJournalQuestions(let category):
            return "/record/register/\(category)"
        case .registJournal(let data, _):
            return "/record/register/\(data.petId)"
        case .deleteJournalList(let id):
            return "/record/\(id)"
        case .getDetailJournalQnA(let petId, let recordID):
            return "/record/detail/\(petId)/\(recordID)"
        case .sendRecordImage(let recordID, _):
            return "/record/register/image/\(recordID)"
        case .makeDiagnosis:
            return "/diagnose/loading"
        case .updateContents(let id, _):
            return "/diagnose/result/\(id)"
        case .getResultDiag(let id):
            return "/diagnose/result/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getJournalList:
            return .get
        case .getJournalQuestions:
            return .get
        case .registJournal:
            return .post
        case .deleteJournalList:
            return .delete
        case .getDetailJournalQnA:
            return .get
        case .sendRecordImage:
            return .post
        case .makeDiagnosis:
            return .post
        case .updateContents:
            return .patch
        case .getResultDiag:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getJournalList(_, _, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .getJournalQuestions:
            return .requestPlain
        case .registJournal(let data, let category):
            let encodedData = encodeRegistJournalData(data: data, category: category)
            return .requestJSONEncodable(encodedData)
        case .deleteJournalList:
            return .requestPlain
        case .getDetailJournalQnA:
            return .requestPlain
        case .sendRecordImage(_, let questionImages):
               var formData = [MultipartFormData]()
               
               // questionImages 딕셔너리를 순회하여 각 질문 ID와 이미지들을 처리
               for (questionID, images) in questionImages {
                   for (index, image) in images.enumerated() {
                       if let imageData = image.jpegData(compressionQuality: 0.8) {
                           let multipartData = MultipartFormData(
                               provider: .data(imageData),
                               name: "images",  // 서버에서 기대하는 필드 이름 (이 경우 "images")
                               fileName: "image\(questionID)_\(index).jpg",
                               mimeType: "image/jpeg"
                           )
                           formData.append(multipartData)
                       }
                   }
                   
                   // question_id를 query parameter로 추가
                   let questionIDData = MultipartFormData(
                       provider: .data("\(questionID)".data(using: .utf8)!),
                       name: "question_id"
                   )
                   formData.append(questionIDData)
               }
               
               return .uploadMultipart(formData)
        case .makeDiagnosis(let data):
            return .requestJSONEncodable(data)
        case .updateContents(_, let data):
            return .requestParameters(parameters: ["products": data], encoding: URLEncoding.default)
        case .getResultDiag:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendRecordImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    
    
    var sampleData: Data {
        switch self {
        case .getJournalList:
            let json =
            """
{
    "isSuccess": true,
    "code": "200",
    "message": "Success",
    "result": {
        "category": "EAR",
        "recordList": [
            {
                "record_id": 1,
                "updatedAtDate": "2024-08-10",
                "updatedAtTime": "14:23:10"
            },
            {
                "record_id": 1,
                "updatedAtDate": "2024-08-10",
                "updatedAtTime": "14:23:10"
            },
            {
                "record_id": 1,
                "updatedAtDate": "2024-08-10",
                "updatedAtTime": "14:23:10"
            },
            {
                "record_id": 1,
                "updatedAtDate": "2024-08-10",
                "updatedAtTime": "14:23:10"
            },
            {
                "record_id": 1,
                "updatedAtDate": "2024-08-10",
                "updatedAtTime": "14:23:10"
            }
        ]
    }
}


"""
            return Data(json.utf8)
        case .getJournalQuestions:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Questions fetched successfully",
                "result": {
                    "category": "EAR",
                    "questions": [
                        {
                            "question_Id": 1,
                            "question_text": "How does your pet feel today?",
                            "subtitle": "Choose the most accurate description",
                            "answer_text": [
                                {
                                    "answerText": "Happy"
                                },
                                {
                                    "answerText": "Sad"
                                },
                                {
                                    "answerText": "Energetic"
                                }
                            ]
                        },
                        {
                            "question_Id": 2,
                            "question_text": "Has your pet eaten well today?",
                            "subtitle": "Check all that apply",
                            "answer_text": [
                                {
                                    "answerText": "Ate normally"
                                },
                                {
                                    "answerText": "Ate less than usual"
                                },
                                {
                                    "answerText": "Did not eat"
                                }
                            ]
                        },
                        {
                            "question_Id": 3,
                            "question_text": "Is your pet drinking water?",
                            "subtitle": "Select the most appropriate answer",
                            "answer_text": [
                                {
                                    "answerText": "Yes, drinking normally"
                                },
                                {
                                    "answerText": "Drinking less than usual"
                                },
                                {
                                    "answerText": "Not drinking at all"
                                }
                            ]
                        }
                    ]
                }
            }
            
            
            """
            return Data(json.utf8)
        default:
            let json = """

"""
            return Data(json.utf8)
        }
    }
    
    private func encodeRegistJournalData(data: RegistJournalData, category: String) -> EncodableRegistJournalData {
        var encodedAnswers = [EncodableRegistJournalData.EncodedAnswer]()
        
        for (questionId, answerText) in data.answers {
            encodedAnswers.append(EncodableRegistJournalData.EncodedAnswer(questionId: questionId, answerText: answerText))
        }
        
        return EncodableRegistJournalData(category: category, answers: encodedAnswers, etc: data.etc)
    }
}
