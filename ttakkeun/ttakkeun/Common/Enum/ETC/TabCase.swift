//
//  TabCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import Foundation
import SwiftUI

enum TabCase: String, CaseIterable {
    
    case home = "home"
    case diagnosis = "diagnosis"
    case schedule = "schedule"
    case suggestion = "suggestion"
    case qna = "qna"
    
    var icon: Image {
        switch self {
        case .home:
            return .init(.home)
        case .diagnosis:
            return .init(.diagnosis)
        case .schedule:
            return .init(.schedule)
        case .suggestion:
            return .init(.suggestion)
        case .qna:
            return .init(.qna)
        }
    }
    
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
