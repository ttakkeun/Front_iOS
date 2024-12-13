//
//  AuthAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation
import Moya

enum AuthAPITarget {
    case sendRefreshToken(refreshToken: String) // Refresh 재발급
    
    case appleLogin(signUpRequest: SignUpRequest) // 애플 로그인 시도
    case signUpAppleLogin(signUpRequest: SignUpRequest) // 애플 회원 가입
    
    case kakakoLogin(signUpRequest: SignUpRequest)
    case signUpKakaoLogin(signUpRequest: SignUpRequest)
}

extension AuthAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .sendRefreshToken:
            return "/api/auth/refresh"
        case .appleLogin:
            return "/api/auth/apple/login"
        case .signUpAppleLogin:
            return "/api/auth/apple/signup"
        case .kakakoLogin:
            return "/api/auth/kakao/login"
        case .signUpKakaoLogin:
            return "/api/auth/kakao/signup"
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
        case .kakakoLogin:
            return .post
        case.signUpKakaoLogin:
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
        case .kakakoLogin(let signUpData):
            return .requestJSONEncodable(signUpData)
        case .signUpKakaoLogin(let signUpData):
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
