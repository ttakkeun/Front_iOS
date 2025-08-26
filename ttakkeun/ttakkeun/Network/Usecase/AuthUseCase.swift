//
//  AuthUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

class AuthUseCase: AuthUseCaseProtocol {
    private let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }
    
    /// 로그아웃
    func executeLogout() -> AnyPublisher<ResponseData<String>, Moya.MoyaError> {
        return service.logout()
    }
    /// 카카오 로그인
    func executeKakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, Moya.MoyaError> {
        return service.kakaoLogin(kakaoLoginRequest: kakaoLoginRequest)
    }
    /// 카카오 회원가입
    func executeSignUpkakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, Moya.MoyaError> {
        return service.signUpkakaoLogin(kakaoLoginRequest: kakaoLoginRequest)
    }
    /// 애플 로그인
    func executeAppleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, Moya.MoyaError> {
        return service.appleLogin(appleLoginRequest: appleLoginRequest)
    }
    
    /// 애플 회원가입
    func executeSignUpApple(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, Moya.MoyaError> {
        return service.signUpAppleLogin(appleLoginRequest: appleLoginRequest)
    }
    
    /// 카카오 계정 삭제
    func executeDeleteKakaoAccount(kakaoDelete: DeleteRequest) -> AnyPublisher<ResponseData<String>, MoyaError> {
        return service.deleteKakaoAccount(kakaoDelete: kakaoDelete)
    }
    
    /// 애플 계정 삭제
    func executeDeleteAppleAccount(appleDelete: DeleteRequest, code: String) -> AnyPublisher<ResponseData<String>, MoyaError> {
        return service.deleteAppleAccount(appleDelete: appleDelete, code: code)
    }
}
