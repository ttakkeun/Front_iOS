//
//  JournalAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation
import Moya

// MARK: - 일지 API Target
enum JournalAPITarget {
    case getJournalList(petID: Int, category: PartItem, page: Int) /* 일지 목록 조회 */
    case getJournalQuestions(category: PartItem) /* 일지 질문 조회 */
    case registJournal(data: RegistJournalData) /* 일지 등록 */
}

extension JournalAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttakkeun.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .getJournalList(let petID, let category, let page):
            return "/record/\(petID)/\(category)/\(page)"
        case .getJournalQuestions(let category):
            return "/record/register/\(category)"
        case .registJournal:
            return "/record/register"
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
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
