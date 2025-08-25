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

protocol ProductUseCaseProtocol {
    func executePutLikeProductData(productId: Int, likeData: ProductLikeRequest) -> AnyPublisher<ResponseData<ProductLikeResponse>, MoyaError>
    func executeGetRankProductTagData(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func executeGetSearchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func executeGetSearchLocal(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func executeGetRankProductData(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func executeGetAIRecommendData(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
