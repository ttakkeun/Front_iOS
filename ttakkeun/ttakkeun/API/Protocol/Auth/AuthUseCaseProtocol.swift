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
    func executeAppleLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func executeSignUpApple(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func executeKakaoLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func executeSignUpkakaoLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
}
