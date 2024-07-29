//
//  PartItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/27/24.
//

import Foundation

/// 따끈에 사용되는 5가지 부위 항목
enum PartItem: String, Codable {
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case tooth = "TOOTH"
    
    /// 부위 항목 서버에서 영어로 돌려받는다. 그 결과를 뷰에 보이기 위해 한글로 전환
    /// - Returns: 번역된 한글 값 전달
    func toKorean() -> String {
        switch self {
        case .ear:
            return "귀"
        case .eye:
            return "눈"
        case .hair:
            return "머리"
        case .claw:
            return "발톱"
        case .tooth:
            return "이빨"
        }
    }
}
