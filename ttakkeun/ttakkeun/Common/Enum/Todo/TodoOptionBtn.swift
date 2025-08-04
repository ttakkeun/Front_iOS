//
//  TodoOptionBtn.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

enum TodoOptionBtn: String, CaseIterable {
    case modify = "수정하기"
    case remove = "삭제하기"
    
    var bgColor: Color {
        switch self {
        case .modify:
            return Color.completionFront
        case .remove:
            return Color.postBg
        }
    }
    
    var fontColor: Color {
        switch self {
        case .modify:
            return Color.gray900
        case .remove:
            return Color.removeBtn
        }
    }
}
