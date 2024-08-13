//
//  QnaPostTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/13/24.
//

import SwiftUI

struct QnaTipsRequestData: Codable {
    var category: TipsCategorySegment
    var title: String
    var content: String
}

struct QnaPostTipsData: Identifiable, Codable {
    var id = UUID()
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [QnaPostTipsResponseData]
}

struct QnaPostTipsResponseData: Codable {
    var category: TipsCategorySegment
    var title: String
    var content: String
}
