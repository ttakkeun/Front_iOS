//
//  NaverShoppingData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/22/24.
//

import Foundation

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

