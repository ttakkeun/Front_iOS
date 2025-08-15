//
//  TodoCompletion.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct TodoCompletionResponse: Codable {
    var partItem: PartItem? = nil
    
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
