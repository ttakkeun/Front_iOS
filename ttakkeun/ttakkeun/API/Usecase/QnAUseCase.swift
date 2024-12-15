//
//  QnAUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import Combine
import CombineMoya
import Moya
import SwiftUI

class QnAUseCase: QnAUseCaseProtocol {
    private let repository: QnARepositoryProtocol
    
    init(repository: QnARepositoryProtocol = QnARepository()) {
        self.repository = repository
    }
    
    func executeGetTipsAll(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return repository.getTipsAll(page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetTipsBest() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return repository.getTipsBest()
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetTips(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return repository.getTips(cateogry: cateogry, page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeWriteTipsData(data: WriteTipsRequest) -> AnyPublisher<ResponseData<TipsResponse>, MoyaError> {
        return repository.writeTips(data: data)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePatchTipsImage(tipId: Int, images: [UIImage]) -> AnyPublisher<ResponseData<[String]>, MoyaError> {
        return repository.patchTipsImage(tipId: tipId, images: images)
            .eraseToAnyPublisher()
    }
    
    func executeTouchScrap(tipId: Int) -> AnyPublisher<ResponseData<TouchScrapResponse>, MoyaError> {
        return repository.touchScrap(tipId: tipId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetMyWriteTips(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return repository.getMyWriteTips(page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetMyScrapTips(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return repository.getMyScrapTips(page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeDeleteMyTips(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        return repository.deleteMyTips(tipId: tipId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
