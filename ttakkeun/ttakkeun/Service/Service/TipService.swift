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

class TipService: TipServiceProtocol, BaseAPIService {
    typealias Target = TipRouter
    
    let provider: MoyaProvider<TipRouter>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<TipRouter> = APIManager.shared.createProvider(for: TipRouter.self),
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }(),
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    /// 팁 신고하기
    func postTipReportData(report: TipReportRequest, images: [Data]?) -> AnyPublisher<ResponseData<TipReportResponse>, Moya.MoyaError> {
        request(.postTipReport(report: report, images: images))
    }
    
    /// 팁 생성
    func postGenerateTipData(tip: TipGenerateRequest) -> AnyPublisher<ResponseData<TipGenerateResponse>, Moya.MoyaError> {
        request(.postGenerateTip(tip: tip))
    }
    
    /// 팁 이미지 업로드
    func patchTipsImageData(tipId: Int, images: [Data]) -> AnyPublisher<ResponseData<String>, Moya.MoyaError> {
        request(.patchTipsImage(tipId: tipId, images: images))
    }
    
    /// 팁 스크랩/취소 토글 기능
    func patchTouchScrapData(tipId: Int) -> AnyPublisher<ResponseData<TipScrapResponse>, Moya.MoyaError> {
        request(.patchTouchScrap(tipId: tipId))
    }
    
    /// 부위별 팁 조회
    func getTipsPartData(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        request(.getTipsPart(category: cateogry, page: page))
    }
    
    /// 내가 작성한 팁 조회
    func getMyWriteTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        request(.getMyWriteTips(page: page))
    }
    
    /// 내가 스크랩한 팁 조회
    func getMyScrapTipsData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        request(.getMyScrapTips(page: page))
    }
    
    /// Best 팁 조회
    func getTipsBestData() -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        request(.getTipsBest)
    }
    
    /// 전체 팁 조회
    func getTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipGenerateResponse]>, Moya.MoyaError> {
        request(.getTipsAll(page: page))
    }
    /// 팁 삭제
    func deleteMyTipsData(tipId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, Moya.MoyaError> {
        request(.deleteMyTips(tipId: tipId))
    }
    
    /// 팁 좋아요/취소 토글
    func patchLikeTip(tipId: Int) -> AnyPublisher<ResponseData<TipLikeResponse>, Moya.MoyaError> {
        request(.patchLikeTip(tipId: tipId))
    }
}
