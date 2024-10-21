//
//  DiagnosticPoint.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import Foundation

/// 진단 탭의 사용자 포인트 조회
struct DiagnosticPoint: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UserPoint
}

struct UserPoint: Codable {
    var point: Int
}
