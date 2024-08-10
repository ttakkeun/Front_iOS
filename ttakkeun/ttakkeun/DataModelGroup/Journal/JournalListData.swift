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
    let result: JournalListResponseData
}

struct JournalListResponseData: Codable {
    let category: PartItem
    let recordList: [JournalRecord]
}

struct JournalRecord: Codable {
    let recordID: Int
    let recordDate: String
    let recordTime: String
    
    enum CodingKeys: String, CodingKey {
        case recordID = "record_id"
        case recordDate = "updatedAtDate"
        case recordTime = "updatedAtTime"
    }
}
