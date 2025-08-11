//
//  InquireReportBtn.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import Foundation
import SwiftUI

enum InquireReportBtnType {
    case inquire
    case report
    
    var text: String {
        switch self {
        case .inquire:
            return "문의하기"
        case .report:
            return "신고하기"
        }
    }
    
    var height: CGFloat {
        return 63
    }
    
    var color: Color {
        return Color.mainPrimary
    }
}
