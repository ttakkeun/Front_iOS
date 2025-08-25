//
//  PetProfileUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Combine
import CombineMoya
import Moya
import SwiftUI

protocol MyPageUseCaseProtocol {
    func executePostGenerateInquire(inquire: MypageInquireRequest, imageData: [Data]?) -> AnyPublisher<ResponseData<MypageInquireResponse>, MoyaError>
    func executeGetMyInquire() -> AnyPublisher<ResponseData<[MyPageMyInquireResponse]>, MoyaError>
    func executePatchEditUserName(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError>
    func executeGetUserInfo() -> AnyPublisher<ResponseData<MyPageUserInfoResponse>, MoyaError>
}
