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

protocol TipServiceProtocol {
    func postTipReportData(report: TipReportRequest, images: [Data]?) -> AnyPublisher<ResponseData<TipReportResponse>, MoyaError>
    func postGenerateTipData(tip: TipGenerateRequest) -> AnyPublisher<ResponseData<TipGenerateResponse>, MoyaError>
    func patchTipsImageData(tipId: Int, images: [Data]) -> AnyPublisher<ResponseData<[String]>, MoyaError>
    func patchTouchScrapData(tipId: Int) -> AnyPublisher<ResponseData<TipScrapResponse>, MoyaError>
    func getTipsPartData(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func getMyWriteTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func getMyScrapTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func getTipsBestData() -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func getTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func deleteMyTipsData(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    func patchLikeTip(tipId: Int) -> AnyPublisher<TipLikeResponse, MoyaError>
}
