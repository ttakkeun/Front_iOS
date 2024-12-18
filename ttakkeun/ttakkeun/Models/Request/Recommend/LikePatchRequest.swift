//
//  LikePatch.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/18/24.
//

import Foundation

struct LikePatchRequest: Codable {
    var title: String
    var image: String
    var price : Int
    var brand: String?
    var link: String
    var category1: String?
    var category2: String?
    var category3: String?
    var category4: String?
}
