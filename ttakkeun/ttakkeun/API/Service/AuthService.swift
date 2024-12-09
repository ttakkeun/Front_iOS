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
    
    func appleLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return provider.requestPublisher(.appleLogin(signUpRequest: signUpRequest))
            .map(ResponseData<TokenResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func signUpAppleLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return provider.requestPublisher(.signUpAppleLogin(signUpRequest: signUpRequest))
            .map(ResponseData<TokenResponse>.self)
            .eraseToAnyPublisher()
    }
}
