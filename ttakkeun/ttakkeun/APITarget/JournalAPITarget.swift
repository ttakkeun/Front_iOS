//
//  JournalAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation
import Moya

///일지 작성 API 타겟
enum JournalAPITarget {
    case getJournalList(petID: Int, category: PartItem, page: Int) /* 일지 목록 조회 */
    case getJournalQuestions(category: PartItem) /* 일지 질문 조회 */
    case registJournal(data: RegistJournalData) /* 일지 등록 */
    case deleteJournalList(journalID: Int) /* 일지 삭제 */
}

extension JournalAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getJournalList(let petID, let category, let page):
            return "/record/\(petID)/\(category)/\(page)"
        case .getJournalQuestions(let category):
            return "/record/register/\(category)"
        case .registJournal(let data):
            return "/record/register/\(data.petId)"
        case .deleteJournalList(let id):
            return "/record/\(id)"
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
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getJournalList:
            return .requestPlain
        case .getJournalQuestions:
            return .requestPlain
        case .registJournal(let data):
            return .requestJSONEncodable(data)
        case .deleteJournalList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
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
                "code": 200,
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
}
