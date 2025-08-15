//
//  TipGenerateDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct TipGenerateRequest: Codable {
    let title: String
    let content: String
    let category: PartItem
}

struct TipGenerateResponse: Identifiable, Codable, Hashable {
    var id = UUID()
    var tipId: Int
    var category: PartItem
    var title: String
    var content: String
    var recommendCount: Int?
    var createdAt: String
    var imageUrls: [String]?
    var authorName: String
    var isLike: Bool
    var isPopular: Bool
    var isScrap: Bool
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
        case isScrap
    }
}
