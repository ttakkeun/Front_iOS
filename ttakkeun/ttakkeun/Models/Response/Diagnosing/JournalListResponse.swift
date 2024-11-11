//
//  JournalListResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/9/24.
//

import Foundation

struct JournalListResponse: Codable {
    var category: PartItem
    var recordList: [JournalListItem]
}

struct JournalListItem: Codable, Hashable, Identifiable {
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
