//
//  RecordListDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct RecordListResponse: Codable {
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
