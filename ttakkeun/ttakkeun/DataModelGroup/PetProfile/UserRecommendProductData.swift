//
//  UserRecommendProduct.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/18/24.
//

import Foundation

struct UserRecommendProductData: Codable {
    var data: [UserRecommendProductResponseData]
}

struct UserRecommendProductResponseData: Codable, Hashable {
    var productImage: String
    var productTitle: String
    var productPrice: Int
    var productCompany: String
}
