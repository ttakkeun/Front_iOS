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

class MyPageService: MyPageServiceProtocol {
    
    private let provider: MoyaProvider<MyPageAPITarget>
    
    init(provider: MoyaProvider<MyPageAPITarget> = APIManager.shared.createProvider(for: MyPageAPITarget.self)) {
        self.provider = provider
    }
    
    func getUserInfoData() -> AnyPublisher<ResponseData<UserInfoResponse>, MoyaError> {
        return provider.requestPublisher(.getUserInfo)
            .map(ResponseData<UserInfoResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func userNameDate(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError> {
        return provider.requestPublisher(.editUserName(newUsername: newUsername))
            .map(ResponseData<String>.self)
            .eraseToAnyPublisher()
    }
}
