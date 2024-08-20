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

struct Diagnosis {
    let id: Int
    let createdAt: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "diagnose_id"
        case createdAt = "created_at"
        case score
    }
}
