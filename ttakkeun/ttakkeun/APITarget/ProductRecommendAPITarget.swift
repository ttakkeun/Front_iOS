//
//  ProductRecommendAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/30/24.
//

import Foundation
import Moya

/// 검색 추천 API Target
enum ProductRecommendAPITarget {
    case getAIRecommend
    case getRankProduct(pageNum: Int)
}

extension ProductRecommendAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttakkeun.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .getAIRecommend:
            return "/product/ai"
        case .getRankProduct(let page):
            return "/product/rank/\(page)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAIRecommend, .getRankProduct:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAIRecommend, .getRankProduct:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
