//
//  RecommendProductData.swift
//  ttakkeun
//
//  Created by 한지강 on 7/22/24.
//

import Foundation

struct RecommenProductResponseData: Codable, Hashable {
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
}
