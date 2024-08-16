//
//  JournalQuestionsData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation

/// 카데고리 선택 시, 카테고리에 해당하는 질문과 답변을 받아온다.
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
    let questionText: String
    let subtitle: String
    let answer: [AnswerDetailData]
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_Id"
        case questionText = "question_text"
        case answer = "answer_text"
        case subtitle
    }
}

struct AnswerDetailData: Codable {
    var answerID =  UUID()
    let answerText: String
}
