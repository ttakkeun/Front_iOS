//
//  QnaTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI

struct QnaTipsData: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: [QnaTipsResponseData]
}

struct QnaTipsResponseData: Identifiable ,Codable {
    var id = UUID()
    var category: TipsCategorySegment
    var title: String
    var content: String
    var userName: String
    var image: String?
    var elapsedTime: Int
    
    var heartNumber: Int?
    
    private enum CodingKeys: String, CodingKey {
        case category
        case title
        case content
        case userName
        case image
        case elapsedTime
        case heartNumber
    }
}
