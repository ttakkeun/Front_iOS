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
    
    typealias Target = AuthRouter
    
    let provider: MoyaProvider<AuthRouter>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<AuthRouter> = APIManager.shared.createProvider(for: AuthRouter.self),
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
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
        request(.kakakoLogin(kakaoLoginRequest: kakaoLoginRequest))
    }
    
    func signUpkakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.signUpKakaoLogin(kakaoLoginRequest: kakaoLoginRequest))
    }
    
    func appleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.appleLogin(appleLoginRequest: appleLoginRequest))
    }
    
    func signUpAppleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        request(.signUpAppleLogin(appleLoginRequest: appleLoginRequest))
    }
    
    func deleteKakaoAccount(kakaoDelete: DeleteRequest) -> AnyPublisher<ResponseData<String>, MoyaError> {
        request(.deleteKakaoAccount(kakaoDelete: kakaoDelete))
    }
    
    func deleteAppleAccount(appleDelete: DeleteRequest, code: String) -> AnyPublisher<ResponseData<String>, MoyaError> {
        request(.deleteAppleAccount(appleDelete: appleDelete, code: code))
    }
}
