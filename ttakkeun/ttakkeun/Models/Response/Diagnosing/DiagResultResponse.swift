//
//  DiagResultResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/8/24.
//

import Foundation

struct DiagResultResponse: Codable {
    var result_id: Int
    var score: Int
    var result_detail: String
    var result_care: String
    var products: [String]
}
