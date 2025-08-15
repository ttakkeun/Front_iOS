//
//  RecordSearchDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct RecordQuestionResponse: Codable {
    let category: String
    let question: [QuestionDetailData]
    
    enum CodingKeys: String, CodingKey {
        case category
        case question = "questions"
    }
}

struct QuestionDetailData: Codable {
    let questionID: Int
    let questionText: String
    let subtitle: String
    let isDupe: Bool
    let answer: [AnswerDetailData]
    
    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case questionText
        case subtitle = "descriptionText"
        case isDupe
        case answer = "answers"
    }
}

struct AnswerDetailData: Codable, Hashable {
    var answerID =  UUID()
    let answerText: String
    
    enum CodingKeys: String, CodingKey {
        case answerText
    }
}
