//
//  ProductResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import Foundation

struct ProductResponse: Codable, Hashable, Identifiable {
    let id = UUID()
    let productId: Int
    let title: String
    let image: String
    let price: Int
    let brand: String
    let purchaseLink: String
    let category1: String?
    let category2: String?
    let category3: String?
    let category4: String?
    var totalLike: Int?
    var likeStatus: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title, image, price, brand, category1, category2, category3, category4
        case purchaseLink = "link"
        case totalLike = "total_likes"
        case likeStatus = "isLike"
        
    }
}
