//
//  AuthAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation
import Moya

enum AuthAPITarget {
    case sendRefreshToken(refreshToken: String)
    case appleLogin(identyToken: String)
    case signUpAppleLogin(signUpRequest: SignUpRequest)
}

extension AuthAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .sendRefreshToken:
            return "api/auth/refresh"
        case .appleLogin:
            return "/api/auth/apple/login"
        case .signUpAppleLogin:
            return "/api/auth/apple/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendRefreshToken:
            return .post
        case .appleLogin:
            return .post
        case .signUpAppleLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendRefreshToken:
            return .requestPlain
        case .appleLogin(let identyToken):
            return .requestParameters(parameters: ["identityToken": identyToken], encoding: JSONEncoding.default)
        case .signUpAppleLogin(let signUpData):
            return .requestJSONEncodable(signUpData)
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        
        switch self {
        case .sendRefreshToken(let refresh):
            headers["RefreshToken"] = "Bearer \(refresh)"
        default:
            break
        }
        
        return headers
    }
}
