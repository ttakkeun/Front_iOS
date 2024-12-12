//
//  QnAService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class QnAService: QnAServiceProtocol {
    
    private let provider: MoyaProvider<QnAAPITarget>
    
    init(provider: MoyaProvider<QnAAPITarget> = APIManager.shared.createProvider(for: QnAAPITarget.self)) {
        self.provider = provider
    }
    
    func getTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return provider.requestPublisher(.getTipsAll(page: page))
            .map(ResponseData<[TipsResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func getTipsBestData() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return provider.requestPublisher(.getTipsBest)
            .map(ResponseData<[TipsResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func getTipsPart(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return provider.requestPublisher(.getTipsPart(category: cateogry, page: page))
            .map(ResponseData<[TipsResponse]>.self)
            .eraseToAnyPublisher()
    }
}
