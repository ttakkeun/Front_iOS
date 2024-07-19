//
//  TodoCompleteData.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/19/24.
//

import Foundation

struct TodoCompleteData: Codable {
    let partType: TodoCompleteType
    let currentInt: CGFloat
    let totalInt: CGFloat
}

enum TodoCompleteType: String, Codable {
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case teeth = "TEETH"
}
