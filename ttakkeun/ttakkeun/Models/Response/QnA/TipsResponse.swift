//
//  TipsResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import Foundation

struct TipsResponse: Identifiable, Codable, Hashable {
    var id = UUID()
    var tipId: Int
    var category: PartItem
    var title: String
    var content: String
    var recommendCount: Int
    var createdAt: String
    var imageUrls: [String]?
    var authorName: String
    var isLike: Bool
    var isPopular: Bool
    var isScrap: Bool = false
    var isExpand: Bool = false
    
    enum CodingKeys: String, CodingKey {
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
