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
}
