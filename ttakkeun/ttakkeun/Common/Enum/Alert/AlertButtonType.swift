//
//  AlertButtonType.swift
//  ttakkeun
//
//  Created by Apple MacBook on 7/17/25.
//

import Foundation
import SwiftUI

/// Alert 버튼 유형
enum AlertButtonType {
    case yes
    case no
    case complete
    
    var text: String {
        switch self {
        case .yes:
            return "예"
        case .no:
            return "아니오"
        case .complete:
            return "완료"
        }
    }
    
    var color: Color {
        switch self {
        case .yes, .complete:
            return .primarycolor200
        case .no:
            return .alertNo
        }
    }
}
