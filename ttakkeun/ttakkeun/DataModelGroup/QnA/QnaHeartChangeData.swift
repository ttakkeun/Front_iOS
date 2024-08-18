//
//  QnaHeartChangeData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/17/24.
//

/// 하트변경할때 받을 Response 데이터
struct QnaHeartChangeData: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: QnaHeartResponseData
}

struct QnaHeartResponseData: Codable {
    let total_likes: Int
    let isLike: Bool
}
