//
//  QnaTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI

/// QnaTipsView에서 Get요청보내고 받을 데이터구조
struct QnaTipsData: Codable {
    var isSuccess: Bool?
    var code: String
    var message: String
    var result: [QnaTipsResponseData]
}

struct QnaTipsResponseData: Identifiable, Codable {
    var id = UUID()  // 고유 ID를 위한 UUID
    var tipId: Int
    var category: TipsCategorySegment
    var title: String
    var content: String
    var recommendCount: Int
    var createdAt: String
    var imageUrls: [String]?
    var authorName: String
    var isLike: Bool
    var isPopular: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case tipId
        case category
        case title
        case content
        case recommendCount
        case createdAt
        case imageUrls
        case authorName
        case isLike
        case isPopular
    }
}
