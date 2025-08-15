//
//  DiagnoseNaverDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct DiagnoseNaverRequest: Codable {
    var products: [String]
}

struct DiagnoseNaverResponse: Codable {
    var products: [Product]
}

struct Product: Codable {
    var productId: Int
    var title: String
    var link: String
    var image: String
    var lprice: Int
    var mall_name: String
    var brand: String
    var category1: String
    var category2: String
    var category3: String
    var category4: String
    var tag: String
}
