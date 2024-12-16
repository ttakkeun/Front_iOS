//
//  ProductRecommendAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya

enum ProductRecommendAPITarget {
    /// AI 추천 상품 API
    case getAIRecommend(petId: Int)
    /// 유저 추천 상품 API
    case getRankProduct(pageNum: Int)
    /// 유저 추천 상품 태그 조회 API
    case getRankProductTag(tag: PartItem.RawValue, page: Int)
    
    case likeProduct(productId: Int)
}

extension ProductRecommendAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getAIRecommend(let id):
            return "/api/product/ai/\(id)"
        case .getRankProduct(let page):
            return "/api/product/rank/\(page)"
        case .getRankProductTag(let tag, let page):
            return "/api/product/tag/\(tag)/\(page)"
        case .likeProduct(let productId):
            return "/api/product/like/\(productId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAIRecommend, .getRankProduct, .getRankProductTag:
            return .get
        case .likeProduct:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAIRecommend, .getRankProduct, .getRankProductTag, .likeProduct:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
