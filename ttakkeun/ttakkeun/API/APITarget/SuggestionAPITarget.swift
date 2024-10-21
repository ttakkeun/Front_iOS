//
//  ProductAPITarget.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import Foundation
import SwiftUI
import Moya

// MARK: - ProductAPITarget 정의
enum SuggestionAPITarget {
    case getAiProducts(petId: Int)
    case getRankedProducts(page: Int)
    case getTagRankingProducts(tag: String, page: Int)
    case getSearchProductsFromDB(keyword: String, page: Int)
    case getSearchProductsFromNaver(keyword: String)
    case toggleLikeProduct(productId: Int, requestBody: ProductRequestDTO)
}

extension SuggestionAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getAiProducts(let petId):
            return "/product/ai/\(petId)"
        case .getRankedProducts(let page):
            return "/product/rank/\(page)"
        case .getTagRankingProducts(let tag, let page):
            return "/product/tag/\(tag)/\(page)"
        case .getSearchProductsFromDB(let keyword, let page):
            return "/product/search_db/\(keyword)/\(page)"
        case .getSearchProductsFromNaver(let keyword):
            return "/product/search_naver/\(keyword)"
        case .toggleLikeProduct(let productId, _):
            return "/product/like/\(productId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAiProducts, .getRankedProducts, .getTagRankingProducts, .getSearchProductsFromDB, .getSearchProductsFromNaver:
            return .get
        case .toggleLikeProduct:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getAiProducts, .getRankedProducts, .getTagRankingProducts, .getSearchProductsFromDB, .getSearchProductsFromNaver:
            return .requestPlain
        case .toggleLikeProduct(_, let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .getAiProducts:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "product_id": 0,
                        "title": "Sample Product",
                        "image": "http://example.com/image.jpg",
                        "price": 1000,
                        "brand": "Sample Brand",
                        "link": "http://example.com/product",
                        "category1": "Category1",
                        "category2": "Category2",
                        "category3": "Category3",
                        "category4": "Category4",
                        "total_likes": 10,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .getRankedProducts:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "product_id": 0,
                        "title": "Sample Product",
                        "image": "http://example.com/image.jpg",
                        "price": 1000,
                        "brand": "Sample Brand",
                        "link": "http://example.com/product",
                        "category1": "Category1",
                        "category2": "Category2",
                        "category3": "Category3",
                        "category4": "Category4",
                        "total_likes": 10,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .getTagRankingProducts:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "product_id": 0,
                        "title": "Sample Product",
                        "image": "http://example.com/image.jpg",
                        "price": 1000,
                        "brand": "Sample Brand",
                        "link": "http://example.com/product",
                        "category1": "Sample Category1",
                        "category2": "Sample Category2",
                        "category3": "Sample Category3",
                        "category4": "Sample Category4",
                        "total_likes": 10,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .getSearchProductsFromDB:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "product_id": 0,
                        "title": "Sample Product",
                        "image": "http://example.com/image.jpg",
                        "price": 1000,
                        "brand": "Sample Brand",
                        "link": "http://example.com/product",
                        "category1": "Sample Category1",
                        "category2": "Sample Category2",
                        "category3": "Sample Category3",
                        "category4": "Sample Category4",
                        "total_likes": 10,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .getSearchProductsFromNaver:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": [
                    {
                        "product_id": 0,
                        "title": "Sample Product",
                        "image": "http://example.com/image.jpg",
                        "price": 1000,
                        "brand": "Sample Brand",
                        "link": "http://example.com/product",
                        "category1": "Sample Category1",
                        "category2": "Sample Category2",
                        "category3": "Sample Category3",
                        "category4": "Sample Category4",
                        "total_likes": 10,
                        "isLike": true
                    }
                ]
            }
            """
            return Data(json.utf8)
            
        case .toggleLikeProduct:
            let json = """
            {
                "isSuccess": true,
                "code": "200",
                "message": "Success",
                "result": {
                    "like": true,
                    "totalLikes": 11
                }
            }
            """
            return Data(json.utf8)
        }
    }
}
