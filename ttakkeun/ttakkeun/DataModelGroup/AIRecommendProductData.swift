//
//  HomeRecommendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/18/24.
//

import Foundation

struct AIRecommendProductData: Codable {
    let data: [AIRecommendProductResponseData]
}

struct AIRecommendProductResponseData: Codable, Hashable {
    let imageUrl: String
    let name: String
    let price: Int
}
