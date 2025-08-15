//
//  DiagnoseDetailDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct DiagnoseDetailResponse: Codable, Identifiable {
    let id: Int
    let score: Int
    let detailValue: String
    let afterCare: String
    let products: [AIProducts]
    
    enum CodingKeys: String, CodingKey {
        case id = "diagnose_id"
        case score
        case detailValue = "result_detail"
        case afterCare = "after_care"
        case products = "ai_products"
    }
}

struct AIProducts: Codable, Hashable, Identifiable {
    var id: UUID = .init()
    let title: String
    let image: String
    let lprice: Int
    let brand: String
}

