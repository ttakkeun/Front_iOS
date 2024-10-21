//
//  CreateDiag.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/22/24.
//

import Foundation

struct CreateDiag: Codable {
    var pet_id: Int
    var records: [RecordID]
}

struct RecordID: Codable {
    var record_id: Int
}

struct DiagResult: Codable {
    var result_id: Int
    var score: Int
    var result_detail: String
    var result_care: String
    var products: [String]
}
