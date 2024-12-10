//
//  CreateDiag.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/8/24.
//

import Foundation

struct CreateDiagRequst: Codable {
    var pet_id: Int
    var records: [RecordID]
}

struct RecordID: Codable {
    var record_id: Int
}
