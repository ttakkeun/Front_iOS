//
//  QnaPostTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/13/24.
//

import SwiftUI

/// QnaWriteTipsView에서 Post할때 보낼 데이터구조
struct QnaTipsRequestData: Codable {
    var category: TipsCategorySegment
    var title: String
    var content: String
}

struct QnaPostTipsData: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: QnaPostTipsResponseData
}

struct QnaPostTipsResponseData: Codable {
    var category: TipsCategorySegment
    var tip_id: Int
    var created_at: String
}
