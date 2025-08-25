//
//  PetProfileService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Foundation
import Combine
import Moya
import SwiftUI

protocol MyPageServiceProtocol {
    func postGenerateInquire(inquire: MypageInquireRequest, imageData: [Data]?) -> AnyPublisher<ResponseData<MypageInquireResponse>, MoyaError>
    
    func getMyInquire() -> AnyPublisher<ResponseData<[MyPageMyInquireResponse]>, MoyaError>
    
    func patchEditUserName(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func getUserInfo() -> AnyPublisher<ResponseData<MyPageUserInfoResponse>, MoyaError>
}
