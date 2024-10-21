//
//  DiagnosisResultList.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/21/24.
//

import Foundation

struct DiagnosisResultList {
    let diagnoses: [Diagnosis]
}

struct Diagnosis: Identifiable, Hashable {
    var id: Int { diagID }
    let diagID: Int
    let createdAt: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case diagID = "diagnose_id"
        case createdAt = "created_at"
        case score
    }
}
