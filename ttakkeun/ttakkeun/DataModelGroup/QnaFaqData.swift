//
//  QnaFaqData.swift
//  ttakkeun
//
//  Created by 한지강 on 7/30/24.
//

import SwiftUI

struct QnaFaqData: Identifiable, Codable {
    var id = UUID()
    var category: PartItem
    var question: String
    var answer: String
    
    
    private enum CodingKeys: String, CodingKey {
        case category, question, answer
    }
}


