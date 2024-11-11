//
//  JournalQuestionResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import Foundation

struct JournalQuestionResponse: Codable {
    let category: String
    let question: [QuestionDetailData]
}

struct QuestionDetailData: Codable {
    let questionID: Int
    let questionText: String
    let subtitle: String
    let isDupe: Bool
    let answer: [AnswerDetailData]
    
}

struct AnswerDetailData: Codable, Hashable {
    var answerID =  UUID()
    let answerText: String
    
    enum CodingKeys: String, CodingKey {
        case answerText
    }
}
