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

class TipUseCase: TipUseCaseProtocol {
    private let service: TipServiceProtocol
    
    init(service: TipServiceProtocol = TipService()) {
        self.service = service
    }
    
    /// 팁 신고하기
    func executePostTipReportData(report: TipReportRequest, images: [Data]?) -> AnyPublisher<ResponseData<TipReportResponse>, Moya.MoyaError> {
        return service.postTipReportData(report: report, images: images)
    }
    /// 팁 생성
    func executePostGenerateTipData(tip: TipGenerateRequest) -> AnyPublisher<ResponseData<TipGenerateResponse>, Moya.MoyaError> {
        return service.postGenerateTipData(tip: tip)
    }
    /// 팁 이미지 업로드
    func executePatchTipsImageData(tipId: Int, images: [Data]) -> AnyPublisher<ResponseData<[String]>, Moya.MoyaError> {
        return service.patchTipsImageData(tipId: tipId, images: images)
    }
    /// 팁 스크랩/취소 토글 기능
    func executePatchTouchScrapData(tipId: Int) -> AnyPublisher<ResponseData<TipScrapResponse>, Moya.MoyaError> {
        return service.patchTouchScrapData(tipId: tipId)
    }
    /// 부위별 팁 조회
    func executeGetTipsPartData(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        return service.getTipsPartData(cateogry: cateogry, page: page)
    }
    /// 내가 작성한 팁 조회
    func executeGetMyWriteTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        return service.getMyWriteTipsData(page: page)
    }
    /// 내가 스크랩한 팁 조회
    func executeGetMyScrapTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        return service.getMyScrapTipsData(page: page)
    }
    /// Best 팁 조회
    func executeGetTipsBestData() -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        return service.getTipsBestData()
    }
    /// 전체 팁 조회
    func executeGetTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        return service.getTipsAllData(page: page)
    }
    /// 팁 삭제
    func executeDeleteMyTipsData(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, Moya.MoyaError> {
        return service.deleteMyTipsData(tipId: tipId)
    }
    /// 팁 좋아요/취소 토글
    func executePatchLikeTip(tipId: Int) -> AnyPublisher<TipLikeResponse, Moya.MoyaError> {
        return service.patchLikeTip(tipId: tipId)
    }
}
