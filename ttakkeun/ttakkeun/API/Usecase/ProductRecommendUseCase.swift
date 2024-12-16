//
//  ScheduleRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Combine
import CombineMoya
import Moya
import SwiftUI

class ProductRecommendUseCase: ProductRecommendUseCaseProtocol {
    private let scheduleRepository: ProductRecommendRepositoryProtocol
    
    init(scheduleRepository: ProductRecommendRepositoryProtocol = ProductRecommendRepository()) {
        self.scheduleRepository = scheduleRepository
    }
    
    func executeGetAIRecommend(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return scheduleRepository.getAIRecommend(petId: petId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetRankProduct(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return scheduleRepository.getRankProduct(pageNum: pageNum)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetRankProductTag(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return scheduleRepository.getRankProductTag(tag: tag, page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeLikeProduct(productId: Int) -> AnyPublisher<ResponseData<LikeTipsResponse>, MoyaError> {
        return scheduleRepository.likeProduct(productId: productId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
