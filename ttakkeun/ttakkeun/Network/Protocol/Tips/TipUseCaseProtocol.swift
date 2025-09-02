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

protocol TipUseCaseProtocol {
    func executePostTipReportData(report: TipReportRequest, images: [Data]?) -> AnyPublisher<ResponseData<TipReportResponse>, MoyaError>
    func executePostGenerateTipData(tip: TipGenerateRequest) -> AnyPublisher<ResponseData<TipGenerateResponse>, MoyaError>
    func executePatchTipsImageData(tipId: Int, images: [Data]) -> AnyPublisher<ResponseData<String>, MoyaError>
    func executePatchTouchScrapData(tipId: Int) -> AnyPublisher<ResponseData<TipScrapResponse>, MoyaError>
    func executeGetTipsPartData(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func executeGetMyWriteTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func executeGetMyScrapTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func executeGetTipsBestData() -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func executeGetTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, MoyaError>
    func executeDeleteMyTipsData(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    func executePatchLikeTip(tipId: Int) -> AnyPublisher<TipLikeResponse, MoyaError>
}
