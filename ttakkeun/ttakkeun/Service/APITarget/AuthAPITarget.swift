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
    
    case kakakoLogin(signUpRequest: SignUpRequest) // 카카오 로그인 시도
    case signUpKakaoLogin(signUpRequest: SignUpRequest) // 카카오 회원 가입
    
    case deleteAppleAccount(authorizationCode: String) // 애플 회원가입 제거
    case logout // 로그아웃
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
        case .deleteAppleAccount:
            return "/api/auth/apple/delete"
        case .logout:
            return "/api/auth/logout"
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
        case .deleteAppleAccount:
            return .delete
        case .logout:
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
        case .deleteAppleAccount:
            return .requestPlain
        case .logout:
            return .requestPlain
        }
    }
    
        var headers: [String : String]? {
            var headers = ["Content-Type": "application/json"]
    
            switch self {
            case .sendRefreshToken(let refresh):
                headers["RefreshToken"] = "Bearer \(refresh)"
            case .deleteAppleAccount(let code):
                headers["authorization-code"] = code
            default:
                break
            }
            return headers
        }
    
}
