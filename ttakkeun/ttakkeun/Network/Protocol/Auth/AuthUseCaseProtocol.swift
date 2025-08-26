//
//  AuthUseCaseProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

protocol AuthUseCaseProtocol {
    func executeLogout() -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func executeKakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func executeSignUpkakaoLogin(kakaoLoginRequest: KakaoLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    
    func executeAppleLogin(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func executeSignUpApple(appleLoginRequest: AppleLoginRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    
    func executeDeleteKakaoAccount(kakaoDelete: DeleteRequest) -> AnyPublisher<ResponseData<String>, MoyaError>
    func executeDeleteAppleAccount(appleDelete: DeleteRequest, code: String) -> AnyPublisher<ResponseData<String>, MoyaError>
}
