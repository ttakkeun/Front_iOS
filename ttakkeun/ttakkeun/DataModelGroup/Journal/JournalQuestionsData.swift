//
//  JournalQuestionsData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation

/// 사용자 기록한 일지 등록 데이터 Response
struct JournalQuestionsData: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: JournalQuestionsDetailData
}

struct JournalQuestionsDetailData: Codable {
    let category: String
    let questions: [QuestionDetailData]
}

struct QuestionDetailData: Codable {
    let questionID: Int
    let quesrtionText: String
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_Id"
        case quesrtionText = "question_text"
    }
}
