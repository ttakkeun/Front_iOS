//
//  AuthService.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import Moya
import Combine
import CombineMoya

class AuthService: AuthServiceProtocol, BaseAPIService {
    typealias Target = AuthAPITarget
    
    let provider: MoyaProvider<AuthAPITarget>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<AuthAPITarget> = APIManager.shared.createProvider(for: AuthAPITarget.self),
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }(),
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func logout() -> AnyPublisher<ResponseData<String>, MoyaError> {
        request(.logout)
    }
    
    func kakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.kakakoLogin(kakaoLoginRequest: .init(accessToken: kakaoLoginRequest.accessToken, email: kakaoLoginRequest.email, name: kakaoLoginRequest.name)))
    }
    
    func signUpkakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.signUpKakaoLogin(kakaoLoginRequest: .init(accessToken: kakaoLoginRequest.accessToken, email: kakaoLoginRequest.email, name: kakaoLoginRequest.name)))
    }
    
    func appleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.appleLogin(appleLoginRequest: .init(identityToken: appleLoginRequest.identityToken, email: appleLoginRequest.email, name: appleLoginRequest.name)))
    }
    
    func signUpAppleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.signUpAppleLogin(appleLoginRequest: .init(identityToken: appleLoginRequest.identityToken, email: appleLoginRequest.email, name: appleLoginRequest.name)))
    }
    
    func deleteKakaoAccount() -> AnyPublisher<ResponseData<String>, Moya.MoyaError> {
        request(.deleteKakaoAccount)
    }
    
    func deleteAppleAccount(authorizationCode: String) -> AnyPublisher<ResponseData<String>, MoyaError> {
        request(.deleteAppleAccount(authorizationCode: authorizationCode))
    }
}
