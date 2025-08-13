//
//  MypageGroupType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/7/25.
//

import Foundation
import SwiftUI

enum MypageGroupType: CaseIterable {
    case appInfo
    case usageInfo
    case account
    
    var title: String {
        switch self {
        case .appInfo:
            "앱 정보"
        case .usageInfo:
            "이용 정보"
        case .account:
            "계정"
        }
    }
    
    var items: [MyPageItemType] {
        switch self {
        case .appInfo:
            return [.terms]
        case .usageInfo:
            return [.inquiry]
        case .account:
            return [.logout, .deleteProfile, .leave]
        }
    }
    
    var font: Font {
        return .Body2_extrabold
    }
    
    var foregroundStyle: Color {
        return .black
    }
}
