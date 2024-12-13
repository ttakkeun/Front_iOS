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
    
    func loginWithApple(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, Moya.MoyaError> {
        return authService.appleLogin(signUpRequest: signUpRequest)
    }
    
    func signUpWithApple(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, Moya.MoyaError> {
        return authService.signUpAppleLogin(signUpRequest: signUpRequest)
    }
    
    func kakaoLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return authService.kakaoLogin(signUpRequest: signUpRequest)
    }
    
    func signUpkakaoLogin(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError> {
        return authService.kakaoLogin(signUpRequest: signUpRequest)
    }
    
}
