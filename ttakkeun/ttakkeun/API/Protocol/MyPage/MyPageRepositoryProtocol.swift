//
//  PetProfileRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

protocol MyPageRepositoryProtocol {
    func getUserInfo() -> AnyPublisher<ResponseData<UserInfoResponse>, MoyaError>
    
    func editUserName(newUsername: String) -> AnyPublisher<ResponseData<String>, MoyaError>
}
