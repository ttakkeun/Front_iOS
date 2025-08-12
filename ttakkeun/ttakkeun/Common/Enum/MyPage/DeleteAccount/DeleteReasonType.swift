//
//  DeleteReasonType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation
import SwiftUI

enum DeleteReasonType: CaseIterable {
    case featureDissatisfaction
    case insufficientContent
    case technicalIssue
    case deviceIncompatibility
    case poorUserExperience
    case other
    
    var text: String {
        switch self {
        case .featureDissatisfaction:
            return "기능 불만족"
        case .insufficientContent:
            return "앱 내 콘텐츠 부족"
        case .technicalIssue:
            return "기술적 문제 (버그, 오류)"
        case .deviceIncompatibility:
            return "기기 호환성 문제"
        case .poorUserExperience:
            return "사용자 경험 불편"
        case .other:
            return "기타 사유"
        }
    }
    
    var font: Font {
        return .Body3_medium
    }
    
    var color: Color {
        return Color.gray400
    }
}
