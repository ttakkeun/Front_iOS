//
//  QnAAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import Foundation
import Moya
import SwiftUI

enum TipRouter {
    /// 팁 신고하기
    case postTipReport(report: TipReportRequest, images: [Data]?)
    /// 팁 생성
    case postGenerateTip(tip: TipGenerateRequest)
    /// 팁 이미지 업로드
    case patchTipsImage(tipId: Int, images: [Data])
    /// 팁 스크랩/취소 토글
    case patchTouchScrap(tipId: Int)
    /// 부위별 팁 조회
    case getTipsPart(category: PartItem.RawValue, page: Int)
    /// 내가 작성한 팁
    case getMyWriteTips(page: Int)
    /// 내가 스크랩한 팁
    case getMyScrapTips(page: Int)
    /// Best 팁 조회
    case getTipsBest
    /// 전체 팁 조회
    case getTipsAll(page: Int)
    /// 나의 팁 제거
    case deleteMyTips(tipId: Int)
    /// 팁 좋아요/취소
    case patchLikeTip(tipId: Int)
}

extension TipRouter: APITargetType {
    var path: String {
        switch self {
        case .postTipReport:
            return "/api/tips/report"
        case .postGenerateTip:
            return "/api/tips/add"
        case .patchTipsImage(let tipId, _):
            return "/api/tips/\(tipId)/images"
        case .patchTouchScrap(let tipId):
            return "/api/tips/scrap/\(tipId)"
        case .getTipsPart:
            return "/api/tips"
        case .getMyWriteTips:
            return "/api/tips/myTips"
        case .getMyScrapTips:
            return "/api/tips/myScraps"
        case .getTipsBest:
            return "/api/tips/best"
        case .getTipsAll:
            return "/api/tips/all"
        case .deleteMyTips(let tipId):
            return "/api/tips/\(tipId)"
        case .patchLikeTip(let tipId):
            return "/api/tips/like/\(tipId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postGenerateTip, .postTipReport:
            return .post
        case .patchLikeTip, .patchTouchScrap, .patchTipsImage:
            return .patch
        case .deleteMyTips:
            return .delete
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postTipReport(let report, let imageData):
            let parts = report.multipartFormParts(jsonFieldName: "postTipReportRequestDTO", images: imageData)
            return .uploadMultipart(parts)
        case .postGenerateTip(let tip):
            let params = try? tip.asDictionary()
            return .requestParameters(parameters: params ?? [:], encoding: URLEncoding.default)
        case .patchTipsImage(_, let imageData):
            let formData: [MultipartFormData] = imageData.enumerated().map { index, data in
                MultipartFormData(
                    provider: .data(data),
                    name: "images",
                    fileName: "image_\(index).jpg",
                    mimeType: "image/jpeg"
                )
            }
            return .uploadMultipart(formData)
        case .getTipsPart(let category, let page):
            return .requestParameters(parameters: ["category": category, "page": page], encoding: URLEncoding.default)
        case .getMyWriteTips(let page), .getMyScrapTips(let page), .getTipsAll(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .deleteMyTips:
            return .requestPlain
        case .patchTouchScrap, .getTipsBest, .patchLikeTip:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .patchTipsImage, .postTipReport:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
