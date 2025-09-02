//
//  TipReportDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct TipReportRequest: Codable {
    let tip_id: Int
    let report_category: String
    let report_detail: String
}

struct TipReportResponse: Codable {
    let reportResult: String
}
