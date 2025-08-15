//
//  DiagnoseResultList.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct DiagnoseListResponse: Codable, Hashable {
    var diagnoses: [DiagDetailData]
}

struct DiagDetailData: Codable, Identifiable, Hashable {
    var id = UUID()
    let diagnoseID: Int
    let createdAt: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case diagnoseID = "diagnose_id"
        case createdAt = "created_at"
        case score
    }
}
