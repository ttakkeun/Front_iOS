//
//  AuthRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

class AuthRepository: AuthRepositoryProtocol {
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func loginWithApple(identityToken: String) -> AnyPublisher<TokenResponse, Moya.MoyaError> {
        return authService.appleLogin(identityToken: identityToken)
    }
    
    func signUpWithApple(signUpRequest: SignUpRequest) -> AnyPublisher<TokenResponse, Moya.MoyaError> {
        return authService.signUpAppleLogin(signUpRequest: signUpRequest)
    }
}
