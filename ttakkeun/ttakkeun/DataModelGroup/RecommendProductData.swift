//
//  HomeRecommendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/18/24.
//

import Foundation

struct RecommendProductData: Codable {
    let data: [RecommendProductResponseData]
}

struct RecommendProductResponseData: Codable, Hashable {
    let imageUrl: String
    let name: String
    let price: Int
}
