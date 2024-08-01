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
    
    var sampleData: Data {
        switch self {
        case .getAIRecommend:
            let json = """
{
  "isSuccess": true,
  "code": 200,
  "message": "Success",
  "result": [
    {
      "product_id": 1,
      "title": "아껴주다 저자극 천연 고양이 샴푸",
      "image": "https://shopping-phinf.pstatic.net/main_8516432/85164327357.jpg",
      "price": 12000,
      "brand": "쿠팡",
      "link": "https://smartstore.naver.com/main/products/7619827035",
      "category1": "건강",
      "category2": "샴푸",
      "category3": "목록",
      "category4": "몰라요",
      "total_likes": 0,
      "isLike": true
    },
    {
      "product_id": 2,
      "title": "아껴주다 저자극 천연 고양이 비누",
      "image": "https://shopping-phinf.pstatic.net/main_4898686/48986864176.20240708011652.jpg",
      "price": 17000,
      "brand": "쿠팡",
      "link": "https://smartstore.naver.com/main/products/7619827035",
      "category1": "건강",
      "category2": "샴푸",
      "category3": "목록",
      "category4": "비누",
      "total_likes": 0,
      "isLike": true
    }
  ]
}
"""
            return Data(json.utf8)
            
        case .getRankProduct:
            let json = """
"""
            return Data(json.utf8)
        }
    }
}
