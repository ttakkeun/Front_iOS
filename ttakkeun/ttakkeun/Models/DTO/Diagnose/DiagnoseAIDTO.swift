//
//  DiagnoseAIDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct DiagnoseAIRequest: Codable {
    var pet_id: Int
    var records: [RecordID]
}

struct RecordID: Codable {
    var record_id: Int
}


struct DiagnoseAIResponse: Codable {
    var resultID: Int
    var score: Int
    var resultDetail: String
    var resultCare: String
    var products: [String]

    enum CodingKeys: String, CodingKey {
        case resultID = "result_id"
        case score
        case resultDetail = "result_detail"
        case resultCare = "result_care"
        case products
    }
}
