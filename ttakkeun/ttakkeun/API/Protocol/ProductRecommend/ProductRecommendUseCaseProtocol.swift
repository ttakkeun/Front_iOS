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

protocol ProductRecommendUseCaseProtocol {
    func executeGetAIRecommend(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func executeGetRankProduct(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
