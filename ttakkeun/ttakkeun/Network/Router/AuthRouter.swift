//
//  AuthAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation
import Moya

enum AuthRouter {
    case sendRefreshToken(refreshToken: String) // Refresh 재발급
    case logout // 로그아웃
    case kakakoLogin(kakaoLoginRequest: KakaoLoginRequest) // 카카오 로그인 시도
    case signUpKakaoLogin(kakaoLoginRequest: KakaoLoginRequest) // 카카오 회원 가입
    case appleLogin(appleLoginRequest: AppleLoginRequest) // 애플 로그인 시도
    case signUpAppleLogin(appleLoginRequest: AppleLoginRequest) // 애플 회원 가입
    case deleteKakaoAccount(kakaoDelete: DeleteRequest) // 카카오 회원가입 제거
    case deleteAppleAccount(appleDelete: DeleteRequest, code: String) // 애플 회원가입 제거
}

extension AuthRouter: APITargetType {
    
    var path: String {
        switch self {
        case .sendRefreshToken:
            return "/api/auth/refresh"
        case .logout:
            return "/api/auth/logout"
        case .kakakoLogin:
            return "/api/auth/kakao/login"
        case .signUpKakaoLogin:
            return "/api/auth/kakao/signup"
        case .appleLogin:
            return "/api/auth/apple/login"
        case .signUpAppleLogin:
            return "/api/auth/apple/signup"
        case .deleteKakaoAccount:
            return "/api/auth/delete/kakao"
        case .deleteAppleAccount:
            return "/api/auth/delete/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteAppleAccount, .deleteKakaoAccount:
            return .delete
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendRefreshToken:
            return .requestPlain
        case .logout:
            return .requestPlain
        case .kakakoLogin(let kakaoLogin):
            return .requestJSONEncodable(kakaoLogin)
        case .signUpKakaoLogin(let kakaoLogin):
            return .requestJSONEncodable(kakaoLogin)
        case .appleLogin(let appleLogin):
            return .requestJSONEncodable(appleLogin)
        case .signUpAppleLogin(let appleLogin):
            return .requestJSONEncodable(appleLogin)
        case .deleteAppleAccount(let delete, _), .deleteKakaoAccount(let delete):
            return .requestJSONEncodable(delete)
            
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        
        switch self {
        case .sendRefreshToken(let refresh):
            headers["RefreshToken"] = "Bearer \(refresh)"
        case .deleteAppleAccount(_, let code):
            headers["authorization-code"] = code
        default:
            break
        }
        return headers
    }
    
}

