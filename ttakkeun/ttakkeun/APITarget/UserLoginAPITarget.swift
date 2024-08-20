//
//  UserLoginAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/22/24.
//

import Foundation
import Moya

/// 유저 로그인 API 타겟
enum UserLoginAPITarget {
    case appleLogin(token: String)
    case appleSignup(token: String, name: String)
}

extension UserLoginAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .appleLogin:
            return "/auth/apple/login"
        case .appleSignup:
            return "/auth/apple/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .post
        case .appleSignup:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .appleLogin(let identyToken):
            return .requestParameters(parameters: ["identityToken": identyToken], encoding: JSONEncoding.default)
        case .appleSignup(let identyToken, let name):
            return .requestParameters(parameters: ["identityToken": identyToken, "userName": name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
