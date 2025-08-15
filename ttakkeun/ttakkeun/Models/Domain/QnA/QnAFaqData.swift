//
//  QnAFaqData.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import Foundation

struct FAQData: Identifiable, Codable {
    var id = UUID()
    var category: PartItem
    var question: String
    var answer: String
    
    private enum CodingKeys: String, CodingKey {
        case category, question, answer
    }
}
