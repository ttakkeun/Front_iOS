//
//  QnaPostTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/13/24.
//

import SwiftUI

/// QnaWriteTipsView에서 Post할 때 보낼 데이터구조
struct QnaTipsRequestData: Codable {
    var category: TipsCategorySegment
    var title: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
          case category = "category"
          case title = "title"
          case content = "content"
      }
}


/// Post 요청에 대한 응답 데이터를 받기 위한 구조체
struct QnaPostTipsData: Codable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: QnaPostTipsResponseData?
}

struct QnaPostTipsResponseData: Codable {
    var tipId: Int
    var category: TipsCategorySegment
    var title: String
    var content: String
    var recommendCount: Int?
    var createdAt: String
    var imageUrls: [String]?
    var authorName: String
    var isLike: Bool
    var isPopular: Bool
    
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
