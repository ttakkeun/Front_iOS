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

protocol ProductRecommendRepositoryProtocol {
    func getAIRecommend(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    
    func getRankProduct(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    
    func getRankProductTag(tag: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    
    func likeProduct(productId: Int, likeData: LikePatchRequest) -> AnyPublisher<ResponseData<LikeTipsResponse>, MoyaError>
}
