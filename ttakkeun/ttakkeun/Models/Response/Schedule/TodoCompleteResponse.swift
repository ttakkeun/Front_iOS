//
//  TodoCompleteResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import Foundation

struct TodoCompleteResponse: Codable {
    let partItem: PartItem? = nil
    
    let earTotal: Int
    let earCompleted: Int
    let hairTotal: Int
    let hairCompleted: Int
    let clawTotal: Int
    let clawCompleted: Int
    let eyeTotal: Int
    let eyeCompleted: Int
    let teethTotal: Int
    let teethCompleted: Int
    
    enum CodingKeys: CodingKey {
        case earTotal
        case earCompleted
        case hairTotal
        case hairCompleted
        case clawTotal
        case clawCompleted
        case eyeTotal
        case eyeCompleted
        case teethTotal
        case teethCompleted
    }
}
