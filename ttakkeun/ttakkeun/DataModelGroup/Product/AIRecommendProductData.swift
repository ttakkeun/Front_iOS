//
//  HomeRecommendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/18/24.
//

import Foundation

struct AIRecommendProductData: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [AIRecommendProductResponseData]
}

struct AIRecommendProductResponseData: Codable, Hashable {
    let likeStatus: Bool
    let totalLike: Int
    let product: [ProductDetailData]
    
    enum CodingKeys: String, CodingKey {
        
        case likeStatus = "likes_status"
        case totalLike = "total_likes"
        case product
    }
}

struct ProductDetailData: Codable, Hashable {
    let productId: Int
    let title: String
    let image: String
    let price: Int
    let brand: String
    let purchaseLink: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title, image, price, brand, category1, category2, category3, category4
        case purchaseLink = "link"
    }
}
