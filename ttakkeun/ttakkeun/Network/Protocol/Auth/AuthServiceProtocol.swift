//
//  AuthServiceProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import Combine
import Moya

protocol AuthServiceProtocol {
    func logout() -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func kakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func signUpkakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    
    func appleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func signUpAppleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>

    func deleteKakaoAccount() -> AnyPublisher<ResponseData<String>, MoyaError>
    func deleteAppleAccount(authorizationCode: String) -> AnyPublisher<ResponseData<String>, MoyaError>
}
