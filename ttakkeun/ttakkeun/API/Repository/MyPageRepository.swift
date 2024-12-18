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

class MyPageRepository: MyPageRepositoryProtocol {
    private let myPageService: MyPageServiceProtocol
    
    init(myPageService: MyPageServiceProtocol = MyPageService()) {
        self.myPageService = myPageService
    }
    
    func getUserInfo() -> AnyPublisher<ResponseData<UserInfoResponse>, MoyaError> {
        return myPageService.getUserInfoData()
    }
    
    func editUserName(newUsername: String)  -> AnyPublisher<ResponseData<String>, MoyaError> {
        return myPageService.userNameDate(newUsername: newUsername)
    }
}
