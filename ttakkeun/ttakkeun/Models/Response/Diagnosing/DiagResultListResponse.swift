//
//  DiagResultListResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/15/24.
//

import Foundation

struct DiagResultListResponse: Codable, Hashable {
    var diagnoses: [diagDetailData]
}

struct diagDetailData: Codable, Identifiable, Hashable {
    var id = UUID()
    let diagnose_id: Int
    let created_at: String
    let score: Int
}
