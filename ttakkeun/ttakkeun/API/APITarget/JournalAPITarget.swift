//
//  JournalAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import Moya

enum JournalAPITarget {
    case getJournalList(petId: Int, category: PartItem.RawValue, page: Int)
}

extension JournalAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getJournalList(let petId, let category, _):
            return "/api/record/\(petId)/\(category)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getJournalList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getJournalList(_, _, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
