//
//  AlertType.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import Foundation

/// Alert 유형
enum AlertType {
    case aiAlert
    case normalAlert
    case editNicknameAlert
    case deleteAccountAlert
    
    var title: String {
        switch self {
        case .aiAlert:
            return "선택된 2개의 일지로 \n따끈 AI 진단을 진행하시겠습니까?"
        case .normalAlert:
            return ""
        case .editNicknameAlert:
            return ""
        case .deleteAccountAlert:
            return ""
        }
    }
}
