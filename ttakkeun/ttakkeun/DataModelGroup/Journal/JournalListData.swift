//
//  JournalListData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import Foundation

/// 일지 목록 조회 Data
struct JournalListData: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: JournalListResponseData
}

struct JournalListResponseData: Codable {
    var category: PartItem
    var recordList: [JournalRecord]
}

struct JournalRecord: Codable, Hashable, Identifiable {
    let id = UUID()
    let recordID: Int
    let recordDate: String
    let recordTime: String
    
    enum CodingKeys: String, CodingKey {
        case recordID = "record_id"
        case recordDate = "updatedAtDate"
        case recordTime = "updatedAtTime"
    }
}
