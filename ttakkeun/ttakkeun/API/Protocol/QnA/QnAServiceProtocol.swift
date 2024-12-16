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

protocol QnAServiceProtocol {
    func getTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func getTipsBestData() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func getTipsPartData(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func writeTipsData(data: WriteTipsRequest) -> AnyPublisher<ResponseData<TipsResponse>, MoyaError>
    
    func patchTipsImageData(tipId: Int, images: [UIImage]) -> AnyPublisher<ResponseData<[String]>, MoyaError>
    
    func touchScrapData(tipId: Int) -> AnyPublisher<ResponseData<TouchScrapResponse>, MoyaError>
    
    func getMyWriteTipsData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func getMyScrapTipsData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    
    func deleteMyTipsData(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    
    func likeTipsData(tipId: Int) -> AnyPublisher<ResponseData<LikeTipsResponse>, MoyaError>
}
