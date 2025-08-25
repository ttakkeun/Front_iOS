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
    private let service: MyPageServiceProtocol
    
    init(service: MyPageServiceProtocol = MyPageService()) {
        self.service = service
    }
    
    func executePostGenerateInquire(inquire: MypageInquireRequest, imageData: [Data]?) -> AnyPublisher<ResponseData<MypageInquireResponse>, Moya.MoyaError> {
        return service.postGenerateInquire(inquire: inquire, imageData: imageData)
    }
    
    func executeGetMyInquire() -> AnyPublisher<ResponseData<[MyPageMyInquireResponse]>, Moya.MoyaError> {
        return service.getMyInquire()
    }
    
    func executePatchEditUserName(newUsername: String) -> AnyPublisher<ResponseData<String>, Moya.MoyaError> {
        return service.patchEditUserName(newUsername: newUsername)
    }
    
    func executeGetUserInfo() -> AnyPublisher<ResponseData<MyPageUserInfoResponse>, Moya.MoyaError> {
        return service.getUserInfo()
    }
    
}
