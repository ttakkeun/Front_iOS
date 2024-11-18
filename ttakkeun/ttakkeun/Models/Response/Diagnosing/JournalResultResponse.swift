//
//  JournalResultResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import Foundation

struct JournalResultResponse: Codable, Hashable {
    let category: PartItem
    let date: String
    let time: String
    let qnaList: [QnAListData]
    let etcString: String?
    
    enum CodingKeys: String, CodingKey {
        case category
        case date
        case time
        case qnaList = "questions"
        case etcString = "etc"
    }
}

struct QnAListData: Codable, Hashable {
    let question: String
    let answer: [String]
    let image: [String]?
    
    enum CodingKeys: String, CodingKey {
        case question
        case answer
        case image = "images"
    }
}
