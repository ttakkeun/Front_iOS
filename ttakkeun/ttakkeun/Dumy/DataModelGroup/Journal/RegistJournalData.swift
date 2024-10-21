//
//  RegistJournalData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation


// MARK: RequestData

/// 일지 생성 시, API로 받은 답변에서 유저가 선택한 답변 저장
struct RegistJournalData: Codable {
    var petId: Int
    var answers: [Int: [String]] = [:]
    var etc: String?
}


// MARK: - ResponseData
struct RecordId: Codable {
    let recordID: Int
    
    enum CodingKeys: String, CodingKey {
        case recordID = "recordId"
    }
}
