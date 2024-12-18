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

class MyPageUseCase: MyPageUseCaseProtocol {
    private let repository: MyPageRepository
    
    init(repository: MyPageRepository = MyPageRepository()) {
        self.repository = repository
    }
    
    func executeMyPage() -> AnyPublisher<ResponseData<UserInfoResponse>, MoyaError> {
        return repository.getUserInfo()
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeEditUserNameDate(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError> {
        return repository.editUserName(newUsername: newUsername)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
