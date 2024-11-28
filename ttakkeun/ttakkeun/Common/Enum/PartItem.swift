//
//  PartItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation
import SwiftUI

/// 따끈에 사용되는 5가지 부위 항목
enum PartItem: String, Codable, CaseIterable {
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case teeth = "TEETH"
    
    /// 부위 항목 서버에서 영어로 돌려받는다. 그 결과를 뷰에 보이기 위해 한글로 전환
    /// - Returns: 번역된 한글 값 전달
    func toKorean() -> String {
        switch self {
        case .ear:
            return "귀"
        case .eye:
            return "눈"
        case .hair:
            return "털"
        case .claw:
            return "발톱"
        case .teeth:
            return "이빨"
        }
    }
    
    func toColor() -> Color {
        switch self {
        case .ear:
            Color.beforeEar
        case .eye:
            Color.beforeEye
        case .hair:
            Color.beforeHair
        case .claw:
            Color.beforeClaw
        case .teeth:
            Color.beforeTeeth
        }
    }
    
    func toAfterColor() -> Color {
        switch self {
        case .ear:
            return Color.afterEar
        case .eye:
            return Color.afterEye
        case .hair:
            return Color.afterHair
        case .claw:
            return Color.afterClaw
        case .teeth:
            return Color.afterTeeth
        }
    }
    
    func toImage() -> Image {
        switch self {
        case .ear:
            return Icon.homeEar.image
        case .eye:
            return Icon.homeEye.image
        case .hair:
            return Icon.homeHair.image
        case .claw:
            return Icon.homeClaw.image
        case .teeth:
            return Icon.homeTeeth.image
        }
    }
}
