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
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    func executeAppleLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return repository.loginWithApple(signUpRequest: signUpRequest)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeSignUpApple(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return repository.signUpWithApple(signUpRequest: signUpRequest)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    func executeKakaoLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return repository.kakaoLogin(signUpRequest: signUpRequest)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeSignUpkakaoLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return repository.signUpkakaoLogin(signUpRequest: signUpRequest)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeDeleteAppleAccount(authorizationCode: String) -> AnyPublisher<ResponseData<String>, MoyaError> {
        return repository.deleteAppleAccount(authorizationCode: authorizationCode)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeLogout() -> AnyPublisher<ResponseData<String>, MoyaError> {
        return repository.logout()
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
