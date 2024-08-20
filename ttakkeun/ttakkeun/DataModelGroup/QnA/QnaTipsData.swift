//
//  QnaTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI

/// QnaTipsView에서 Get요청보내고 받을 데이터구조
struct QnaTipsData: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: QnaTipsResult
}

struct QnaTipsResult: Codable {
    var tips: [QnaTipsResponseData]
}

struct QnaTipsResponseData: Identifiable ,Codable {
    var id = UUID()
    var tip_id: Int
    var category: TipsCategorySegment
    var author: String
    var popular: Bool
    var title: String
    var content: String
    var image_url: String?
    var created_at: Int
    var recommend_count: Int?
    
    private enum CodingKeys: String, CodingKey {
        case tip_id
        case category
        case author
        case popular
        case title
        case content
        case image_url
        case created_at
        case recommend_count
    }

}
