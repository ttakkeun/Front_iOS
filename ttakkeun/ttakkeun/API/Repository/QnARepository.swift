//
//  QnARepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class QnARepository: QnARepositoryProtocol {
    
    private let qnaService: QnAServiceProtocol
    
    init(qnaService: QnAServiceProtocol = QnAService()) {
        self.qnaService = qnaService
    }
    
    func getTipsAll(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return qnaService.getTipsAllData(page: page)
    }
    
    func getTipsBest() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return qnaService.getTipsBestData()
    }
    
    func getTips(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return qnaService.getTipsPartData(cateogry: cateogry, page: page)
    }
    
    func writeTips(data: WriteTipsRequest) -> AnyPublisher<ResponseData<TipsResponse>, MoyaError> {
        return qnaService.writeTipsData(data: data)
    }
    
    func patchTipsImage(tipId: Int, images: [UIImage]) -> AnyPublisher<ResponseData<[String]>, MoyaError> {
        return qnaService.patchTipsImageData(tipId: tipId, images: images)
    }
    
    func touchScrap(tipId: Int) -> AnyPublisher<ResponseData<TouchScrapResponse>, MoyaError> {
        return qnaService.touchScrapData(tipId: tipId)
    }
    
    func getMyWriteTips(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return qnaService.getMyWriteTipsData(page: page)
    }
    
    func getMyScrapTips(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError> {
        return qnaService.getMyScrapTipsData(page: page)
    }
    
    func deleteMyTips(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        return qnaService.deleteMyTipsData(tipId: tipId)
    }
    
    func likeTips(tipId: Int) -> AnyPublisher<LikeTipsResponse, MoyaError> {
        return qnaService.likeTipsData(tipId: tipId)
    }
    
}
