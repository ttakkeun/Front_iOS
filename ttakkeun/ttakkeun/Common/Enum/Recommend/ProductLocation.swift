//
//  ProductLocation.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import Foundation
import SwiftUI

enum ProductLocation {
    case naver
    case localDB
    
    var backgroundColor: Color {
        switch self {
        case .naver:
            return Color.searchBg
        case .localDB:
            return Color.primarycolor400
        }
    }
    
    var productSize: (CGFloat, CGFloat) {
        switch self {
        case .naver:
            return (95, 95)
        case .localDB:
            return (64, 64)
        }
    }
    
    var backgroundPadding: (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch self {
        case .naver:
            return (10, 10, 10, 10)
        case .localDB:
            return (21, 21, 19, 19)
        }
    }
}
