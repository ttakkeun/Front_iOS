//
//  RecommendProductData.swift
//  ttakkeun
//
//  Created by 한지강 on 7/22/24.
//

import Foundation

struct RecommenProductResponseData: Codable, Hashable, Identifiable {
    var id = UUID()
    var product_id: Int
    var title: String
    var image: String
    var price: Int
    var brand: String
    var link: String
    var category1: String
    var category2: String
    var category3: String
    var category4: String
    var total_likes: Int
    var  isLike: Bool
    
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

struct ProductRequestDTO: Encodable {
    let title: String
    let image: String
    let price: Int
    let brand: String
    let link: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
}

struct LikeResponseDTO: Codable {
    let like: Bool
    let totalLikes: Int
    
    private enum CodingKeys: String, CodingKey {
        case like
        case totalLikes = "total_likes"
    }
}
