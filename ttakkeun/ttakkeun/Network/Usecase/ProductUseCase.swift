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

class ProductUseCase: ProductUseCaseProtocol {
    private let service: ProductServiceProtocol
    
    init(service: ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    
    func executePutLikeProductData(productId: Int, likeData: ProductLikeRequest) -> AnyPublisher<ResponseData<ProductLikeResponse>, Moya.MoyaError> {
        return service.putLikeProductData(productId: productId, likeData: likeData)
    }
    
    func executeGetRankProductTagData(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        return service.getRankProductTagData(tag: tag, page: page)
    }
    
    func executeGetSearchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        return service.getSearchNaver(keyword: keyword)
    }
    
    func executeGetSearchLocal(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        return service.getSearchLocal(keyword: keyword, page: page)
    }
    
    func executeGetRankProductData(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        return service.getRankProductData(pageNum: pageNum)
    }
    
    func executeGetAIRecommendData(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        return service.getAIRecommendData(petId: petId)
    }
}
