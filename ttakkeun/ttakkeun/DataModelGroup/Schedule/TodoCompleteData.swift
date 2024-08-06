//
//  TodoCompleteData.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/19/24.
//

import Foundation

/// 일정 - 투두 완수율 조회 데이터
struct TodoCompleteData: Codable {
    let partType: PartItem
    let currentInt: CGFloat
    let totalInt: CGFloat
}

