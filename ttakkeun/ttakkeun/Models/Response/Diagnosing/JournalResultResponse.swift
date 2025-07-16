//
//  JournalResultResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import Foundation

/// 일지 생성 시 선택 및 입력했던 일지 내용 결과
struct JournalResultResponse: Codable, Identifiable, Hashable {
    let id: UUID = .init()
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
