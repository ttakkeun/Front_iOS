//
//  DiagnosticResultAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import Foundation
import Moya

enum DiagnosticResultAPITarget {
    case getPoint
}

extension DiagnosticResultAPITarget: APITargetType {
    var path: String {
        switch self {
        case .getPoint:
            return "/diagnose/point"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPoint:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPoint:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .getPoint:
            let json = """
{
    "isSuccess": true,
    "code" : "COMMON200",
    "message" : "성공입니다.",
    "result" :
        {
            "point": 9
        }
}
"""
            return Data(json.utf8)
        }
    }
}
