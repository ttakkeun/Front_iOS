//
//  ttakkeunTab.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import Foundation
import SwiftUI

/// 따끈 탭 enum
enum TabCase: String, CaseIterable {
    
    case home = "home"
    case diagnosis = "diagnosis"
    case schedule = "schedule"
    case suggestion = "suggestion"
    case qna = "qna"
    
    func toKorean() -> String {
        switch self {
        case .home:
            return "홈"
        case .diagnosis:
            return "진단"
        case .schedule:
            return "일정"
        case .suggestion:
            return "추천"
        case .qna:
            return "Q&A"
        }
    }
}
