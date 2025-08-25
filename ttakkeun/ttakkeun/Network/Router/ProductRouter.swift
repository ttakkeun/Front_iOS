//
//  ProductRecommendAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya

enum ProductRouter {
    /// 좋아요 취소 토글
    case putLikeProduct(productId: Int, likeData: ProductLikeRequest)
    /// 랭킹별 추천 제품 조회
    case getRankProductTag(tag: PartItem.RawValue, page: Int)
    /// 검색 조회(네이버 쇼핑)
    case getSearchNaver(keyword: String)
    /// 검색 조회(따끈 DB)
    case getSearchLocal(keyword: String, page: Int)
    /// 랭킹별 추천 제품 조회
    case getRankProduct(page: Int)
    /// 가장 최근 진단 기준 최대 5개의 추천 제품 조회
    case getAIRecommend(petId: Int)
    
   
}

extension ProductRouter: APITargetType {
    
    var path: String {
        switch self {
        case .putLikeProduct(let productId, _):
            return "/api/product/like/\(productId)"
        case .getRankProductTag(let tag, let page):
            return "/api/product/tag/\(tag)/\(page)"
        case .getSearchNaver(let keyword):
            return "/api/product/search_naver/\(keyword)"
        case .getSearchLocal(let keyword, let page):
            return "/api/product/search_db/\(keyword)/\(page)"
        case .getRankProduct(let page):
            return "/api/product/rank/\(page)"
        case .getAIRecommend(let petId):
            return "/api/product/ai/\(petId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putLikeProduct:
            return .put
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .putLikeProduct(_, let like):
            return .requestJSONEncodable(like)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
