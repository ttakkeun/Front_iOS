//
//  RecommendProductData.swift
//  ttakkeun
//
//  Created by 한지강 on 7/22/24.
//

import Foundation

struct RecommenProductResponseData: Codable, Hashable, Identifiable {
    var id = UUID()
    let product_id: Int
    let title: String
    let image: String
    let price: Int
    let brand: String
    let link: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    let total_likes: Int
    let isLike: Bool
    
    private enum CodingKeys: String, CodingKey {
        case product_id
        case title
        case image
        case price
        case brand
        case link
        case category1
        case category2
        case category3
        case category4
        case total_likes
        case isLike
        
    }

}
