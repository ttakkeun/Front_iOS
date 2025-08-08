//
//  MyPageItemType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/8/25.
//

import Foundation
import SwiftUI

enum MyPageItemType {
    case terms
    case inquiry
    case report
    case logout
    case deleteProfile
    case leave
    
    var title: String {
        switch self {
        case .terms:
            return "이용 약관 및 정책"
        case .inquiry:
            return "문의 하기"
        case .report:
            return "신고 하기"
        case .logout:
            return "로그아웃하기"
        case .deleteProfile:
            return "프로필 삭제하기"
        case .leave:
            return "탈퇴하기"
        }
    }
    
    var isDestructive: Bool {
        return self == .leave
    }
    
    var font: Font {
        return .Body3_medium
    }
    
    var foregroundStyle: Color {
        switch self {
        case .leave:
            return Color.removeBtn
        default:
            return Color.black
        }
    }
}
