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

protocol ProductServiceProtocol {
    func putLikeProductData(productId: Int, likeData: ProductLikeRequest) -> AnyPublisher<ResponseData<ProductLikeResponse>, MoyaError>
    func getRankProductTagData(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func getSearchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func getSearchLocal(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func getRankProductData(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func getAIRecommendData(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
