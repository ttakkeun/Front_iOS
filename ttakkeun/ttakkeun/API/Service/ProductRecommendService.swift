//
//  ScheduleRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class ProductRecommendService: ProductRecommendServiceProtocol {
    
    private let provider: MoyaProvider<ProductRecommendAPITarget>
    
    init(provider: MoyaProvider<ProductRecommendAPITarget> = APIManager.shared.createProvider(for: ProductRecommendAPITarget.self)) {
        self.provider = provider
    }
    
    func getAIRecommendData(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return provider.requestPublisher(.getAIRecommend(petId: petId))
            .map(ResponseData<[ProductResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func getRankProductData(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return provider.requestPublisher(.getRankProduct(pageNum: pageNum))
            .map(ResponseData<[ProductResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func getRankProductTagData(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return provider.requestPublisher(.getRankProductTag(tag: tag, page: page))
            .map(ResponseData<[ProductResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func likeProductData(productId: Int) -> AnyPublisher<ResponseData<LikeTipsResponse>, MoyaError> {
        return provider.requestPublisher(.likeProduct(productId: productId))
            .map(ResponseData<LikeTipsResponse>.self)
            .eraseToAnyPublisher()
    }
}
