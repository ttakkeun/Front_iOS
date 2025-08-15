//
//  RecordGenerateDTO]\.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct RecordGenerateRequest: Codable {
    var petId: Int
    var answers: [Int: [String]]
    var etc: String?
    
    init(
        petId: Int,
        answers: [Int : [String]] = [:],
        etc: String? = nil
    ) {
        self.petId = petId
        self.answers = answers
        self.etc = etc
    }
}

struct RecordGenerateResponse: Codable, Hashable {
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
