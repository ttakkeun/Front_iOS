//
//  EncodableRegistJournalData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/21/24.
//

import Foundation

struct EncodableRegistJournalData: Codable {
    var category: String
    var answers: [EncodedAnswer]
    var etc: String?
    
    struct EncodedAnswer: Codable {
        var questionId: Int
        var answerText: [String]
    }
}

