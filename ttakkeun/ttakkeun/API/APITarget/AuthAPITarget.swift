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
    case appleLogin(signUpRequest: SignUpRequest)
    case signUpAppleLogin(signUpRequest: SignUpRequest)
}

extension AuthAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .sendRefreshToken:
            return "/auth/refresh"
        case .appleLogin:
            return "/auth/apple/login"
        case .signUpAppleLogin:
            return "/auth/apple/signup"
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
        case .appleLogin(let signUpData):
            return .requestJSONEncodable(signUpData)
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
