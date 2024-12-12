//
//  QnAAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import Moya

enum QnAAPITarget {
    case getTipsAll(page: Int)
    case getTipsBest
    case getTipsPart(category: PartItem.RawValue, page: Int)
}

extension QnAAPITarget: APITargetType {
    var path: String {
        switch self {
        case .getTipsAll:
            return "/api/tips/all"
        case .getTipsBest:
            return "/api/tips/best"
        case .getTipsPart:
            return "/api/tips"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTipsAll, .getTipsBest, .getTipsPart:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getTipsAll(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .getTipsBest:
            return .requestPlain
        case .getTipsPart(let category, let page):
            return .requestParameters(parameters: ["category": category, "page": page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
