//
//  AuthAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import Moya

/// 토큰 Refresh 초기화 API 호출
enum AuthAPITarget {
    case refreshToken(currentToken: String)
}

extension AuthAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "example")!
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .refreshToken(let token):
            return .requestParameters(parameters: ["currentToken": token], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
