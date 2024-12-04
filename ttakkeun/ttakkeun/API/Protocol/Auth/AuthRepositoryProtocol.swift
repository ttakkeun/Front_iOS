//
//  AuthRepositoryProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import CombineMoya
import Combine
import Moya

protocol AuthRepositoryProtocol {
    func loginWithApple(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
    func signUpWithApple(signUpRequest: SignUpRequest) -> AnyPublisher<ResponseData<TokenResponse>, MoyaError>
}
