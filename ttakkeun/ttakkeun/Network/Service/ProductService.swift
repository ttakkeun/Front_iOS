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

class ProductService: ProductServiceProtocol, BaseAPIService {
    typealias Target = ProductRouter
    
    let provider: MoyaProvider<ProductRouter>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<ProductRouter> = APIManager.shared.createProvider(for: ProductRouter.self),
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func putLikeProductData(productId: Int, likeData: ProductLikeRequest) -> AnyPublisher<ResponseData<ProductLikeResponse>, Moya.MoyaError> {
        request(.putLikeProduct(productId: productId, likeData: likeData))
    }
    
    func getRankProductTagData(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        request(.getRankProductTag(tag: tag, page: page))
    }
    
    func getSearchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        request(.getSearchNaver(keyword: keyword))
    }
    
    func getSearchLocal(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        request(.getSearchLocal(keyword: keyword, page: page))
    }
    
    func getRankProductData(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        request(.getRankProduct(page: pageNum))
    }
    
    func getAIRecommendData(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, Moya.MoyaError> {
        request(.getAIRecommend(petId: petId))
    }
}
