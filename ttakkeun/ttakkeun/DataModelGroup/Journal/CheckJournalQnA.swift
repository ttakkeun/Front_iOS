//
//  CheckJournalQnA.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/17/24.
//

import Foundation

/// 일지 생성 후, 질문에 대해 답변과 첨부한 이미지 서버로부터 저장됐는지 재확인 데이터 모델
struct CheckJournalQnAResponseData: Codable, Hashable {
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
