//
//  AuthServiceProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/27/24.
//

import Foundation
import Combine
import Moya

protocol AuthServiceProtocol {
    func appleLogin(identityToken: String) -> AnyPublisher<TokenResponse, MoyaError>
    func signUpAppleLogin(signUpRequest: SignUpRequest) -> AnyPublisher<TokenResponse, MoyaError>
}
