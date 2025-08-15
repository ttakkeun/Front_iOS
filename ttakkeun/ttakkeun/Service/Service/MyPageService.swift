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

class MyPageService: MyPageServiceProtocol, BaseAPIService {
    typealias Target = MyPageRouter
    
    let provider: MoyaProvider<MyPageRouter>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<MyPageRouter> = APIManager.shared.createProvider(for: MyPageRouter.self),
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }(),
        callbackQueue: DispatchQueue = .main
        
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func postGenerateInquire(inquire: MypageInquireRequest, imageData: [Data]) -> AnyPublisher<ResponseData<MypageInquireResponse>, Moya.MoyaError> {
        request(.postGenerateInquire(inquire: inquire, imageData: imageData))
    }
    
    func getMyInquire() -> AnyPublisher<ResponseData<[MyPageMyInquireResponse]>, Moya.MoyaError> {
        request(.getMyInquire)
    }
    
    func patchEditUserName(newUsername: String) -> AnyPublisher<ResponseData<String>, Moya.MoyaError> {
        request(.patchEditUserName(newUsername: newUsername))
    }
    
    func getUserInfo() -> AnyPublisher<ResponseData<MyPageUserInfoResponse>, Moya.MoyaError> {
        request(.getUserInfo)
    }
}
