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
    
    func executeAppleLogin(identityToken: String) -> AnyPublisher<TokenResponse, MoyaError> {
        return repository.loginWithApple(identityToken: identityToken)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeSignUpApple(signUpRequest: SignUpRequest) -> AnyPublisher<TokenResponse, MoyaError> {
        return repository.signUpWithApple(signUpRequest: signUpRequest)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
