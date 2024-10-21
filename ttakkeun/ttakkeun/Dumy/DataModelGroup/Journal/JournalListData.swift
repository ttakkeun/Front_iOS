//
//  JournalListData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import Foundation

/// 일지 목록 조회 Data
struct JournalListResponseData: Codable {
    var category: PartItem
    var recordList: [JournalRecord]
}

struct JournalRecord: Codable, Hashable, Identifiable {
    var id = UUID()
    var recordID: Int
    var recordDate: String
    var recordTime: String
    
    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
        case recordDate = "createdAtDate"
        case recordTime = "createdAtTime"
    }
}
