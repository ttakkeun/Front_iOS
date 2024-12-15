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
import SwiftUI

protocol QnAUseCaseProtocol {
    func executeGetTipsAll(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func executeGetTipsBest() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func executeGetTips(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func executeWriteTipsData(data: WriteTipsRequest) -> AnyPublisher<ResponseData<TipsResponse>, MoyaError>
    
    func executePatchTipsImage(tipId: Int, images: [UIImage]) -> AnyPublisher<ResponseData<[String]>, MoyaError>
    
    func executeTouchScrap(tipId: Int) -> AnyPublisher<ResponseData<TouchScrapResponse>, MoyaError>
    
    func executeGetMyWriteTips(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func executeGetMyScrapTips(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func executeDeleteMyTips(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    
    func executeLikeTips(tipId: Int) -> AnyPublisher<ResponseData<LikeTipsResponse>, MoyaError>
}
