//
//  RecommendProductData.swift
//  ttakkeun
//
//  Created by 한지강 on 7/22/24.
//


struct RecommenProductData: Codable {
    var data: [RecommenProductResponseData]
}

struct RecommenProductResponseData : Codable, Hashable {
    var title: String
    var image: String
    var lprice: Int
    var mallName: String
    var category2: String
    var category3: String
    var category4: String
    
    var productHeartNum: Int?
}
