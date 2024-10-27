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

class AuthService: AuthServiceProtocol {
    private let provider: MoyaProvider<AuthAPITarget>
    
    init(provider: MoyaProvider<AuthAPITarget> = APIManager.shared.createProvider(for: AuthAPITarget.self)) {
        self.provider = provider
    }
    
    func appleLogin(identityToken: String) -> AnyPublisher<TokenResponse, MoyaError> {
        return provider.requestPublisher(.appleLogin(identyToken: identityToken))
            .map(TokenResponse.self)
            .eraseToAnyPublisher()
    }
    
    func signUpAppleLogin(signUpRequest: SignUpRequest) -> AnyPublisher<TokenResponse, MoyaError> {
        return provider.requestPublisher(.signUpAppleLogin(signUpRequest: signUpRequest))
            .map(TokenResponse.self)
            .eraseToAnyPublisher()
    }
}
