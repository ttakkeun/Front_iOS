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

class ProductRecommendRepository: ProductRecommendRepositoryProtocol {
    
    private let productService: ProductRecommendServiceProtocol
    
    init(productService: ProductRecommendServiceProtocol = ProductRecommendService()) {
        self.productService = productService
    }
    
    func getAIRecommend(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return productService.getAIRecommendData(petId: petId)
    }
    
    func getRankProduct(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return productService.getRankProductData(pageNum: pageNum)
    }
    
    func getRankProductTag(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return productService.getRankProductTagData(tag: tag, page: page)
    }
    
    func likeProduct(productId: Int) -> AnyPublisher<ResponseData<LikeTipsResponse>, MoyaError> {
        return productService.likeProductData(productId: productId)
    }
}
