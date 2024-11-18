//
//  SelectedAnswerData.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import Foundation

struct SelectedAnswerData: Codable {
    var petId: Int
    var answers: [Int: [String]]
    var etc: String?
    
    init(
        petId: Int,
        answers: [Int : [String]] = [:],
        etc: String? = nil
    ) {
        self.petId = petId
        self.answers = answers
        self.etc = etc
    }
}
