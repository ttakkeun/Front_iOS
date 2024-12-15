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
    
    func touchScrapData(tipId: Int) -> AnyPublisher<ResponseData<TouchScrapResponse>, MoyaError> {
        return provider.requestPublisher(.touchScrap(tipId: tipId))
            .map(ResponseData<TouchScrapResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getMyWriteTipsData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return provider.requestPublisher(.getMyWriteTips(page: page))
            .map(ResponseData<[TipsResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func getMyScrapTipsData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return provider.requestPublisher(.getMyScrapTips(page: page))
            .map(ResponseData<[TipsResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func deleteMyTipsData(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        return provider.requestPublisher(.deleteMyTips(tipId: tipId))
            .map(ResponseData<EmptyResponse>.self)
            .eraseToAnyPublisher()
    }
}
