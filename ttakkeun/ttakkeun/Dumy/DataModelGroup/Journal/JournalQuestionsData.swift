//
//  JournalQuestionsData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation

/// 카데고리 선택 시, 카테고리에 해당하는 질문과 답변을 받아온다.
struct JournalQuestionsDetailData: Codable {
    let category: String
    let questions: [QuestionDetailData]
    
}

struct QuestionDetailData: Codable {
    let questionID: Int
    let questionText: String
    let subtitle: String
    let isDupe: Bool
    let answer: [AnswerDetailData]
    
    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case questionText = "questionText"
        case answer = "answers"
        case subtitle = "descriptionText"
        case isDupe
    }
}

struct AnswerDetailData: Codable, Hashable {
    var answerID =  UUID()
    let answerText: String
    
    enum CodingKeys: String, CodingKey {
        case answerText
    }
}
