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
    
    func getTipsPartData(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return provider.requestPublisher(.getTipsPart(category: cateogry, page: page))
            .map(ResponseData<[TipsResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func writeTipsData(data: WriteTipsRequest) -> AnyPublisher<ResponseData<TipsResponse>, MoyaError> {
        return provider.requestPublisher(.writeTips(data: data))
            .map(ResponseData<TipsResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func patchTipsImageData(tipId: Int, images: [UIImage]) -> AnyPublisher<ResponseData<[String]>, MoyaError> {
        return provider.requestPublisher(.patchTipsImage(tipId: tipId, images: images))
            .map(ResponseData<[String]>.self)
            .eraseToAnyPublisher()
    }
}
