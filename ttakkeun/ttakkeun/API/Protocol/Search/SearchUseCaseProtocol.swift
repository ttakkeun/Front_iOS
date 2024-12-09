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

protocol SearchUseCaseProtocol {
    func executeSearchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func executeSearchLocalDB(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
