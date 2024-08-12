//
//  QnaTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI
//
//struct QnaTipsRequestData: Codable {
//    var category: TipsCategorySegment
//    var title: String
//    var content: String
//    var userName: String
//    var image: String?
//}
//
//struct QnaTipsResponseData: Identifiable, Codable {
//    var id: UUID()
//    var category: TipsCategorySegment
//    var title: String
//    var content: String
//    var userName: String
//    
//}

struct QnaTipsData : Identifiable, Codable {
    var id = UUID()
    var category: TipsCategorySegment
    var title: String
    var content: String
    var userName: String
    var elapsedTime: Int
    
    var heartNumber: Int?
}
