//
//  TopTenQuestionData.swift
//  ttakkeun
//
//  Created by 한지강 on 7/28/24.
//

import Foundation

struct TopTenQuestionData: Identifiable, Codable {
    var id = UUID()
    var category: CategoryType
    var content: String
}

enum CategoryType: String, Codable, CaseIterable {
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case teeth = "TEETH"
}



