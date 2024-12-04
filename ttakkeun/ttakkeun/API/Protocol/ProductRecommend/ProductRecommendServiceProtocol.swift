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
import SwiftUI

protocol ProductRecommendServiceProtocol {
    func getAIRecommendData(petId: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func getRankProductData(pageNum: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
