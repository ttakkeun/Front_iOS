//
//  DiagnosticResultAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import Foundation
import Moya

enum DiagnosticResultAPITarget {
    /// 진단 생성 포인트 조회
    case getPoint
    /// 진단서 상세 내용 조회
    case getDiagnosisDetail(diagnosisId: Int)
    
}

extension DiagnosticResultAPITarget: APITargetType {
    var path: String {
        switch self {
        case .getPoint:
            return "/api/diagnose/point"
        case .getDiagnosisDetail(let id):
            return "/api/diagnose/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPoint:
            return .get
        case .getDiagnosisDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPoint:
            return .requestPlain
        case .getDiagnosisDetail:
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
        default:
            let json = """
"""
            return Data(json.utf8)
        }
    }
}
