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
    func executeMyPage() -> AnyPublisher<ResponseData<UserInfoResponse>, MoyaError>
    
    func executeEditUserNameDate(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func executeLogout() -> AnyPublisher<ResponseData<String>, MoyaError>
    
    func executeDeleteProfile(petId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
}
