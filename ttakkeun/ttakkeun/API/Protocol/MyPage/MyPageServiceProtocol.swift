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
    func getUserInfoData() -> AnyPublisher<ResponseData<UserInfoResponse>, MoyaError>
    
    func userNameDate(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func logoutData() -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func deleteProfileData(petId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    
    func getMyInquireData() -> AnyPublisher<ResponseData<[MyInquiryResponse]>, MoyaError>
}
