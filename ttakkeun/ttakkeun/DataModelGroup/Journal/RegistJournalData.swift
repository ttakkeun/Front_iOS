//
//  RegistJournalData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation


// MARK: RequestData

struct RegistJournalData: Codable {
    var petId: Int
    var category: PartItem
    var answer1: String
    var answer2: String
    var answer3: String
    var etc: String
}


// MARK: - ResponseData
struct RegistJournalResponseData: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
