//
//  MakeJournalResultResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/7/24.
//

import Foundation

struct MakeJournalResultResponse: Codable, Hashable {
    let recordId: Int
    let category: PartItem
    let answers: [QnAListData]
    let etcString: String?
    
    enum CodingKeys: String, CodingKey {
        case recordId
        case category
        case answers
        case etcString = "etc"
    }
}
