//
//  TipsExpandType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/2/25.
//

import Foundation

enum TipsExpandType {
    case beforeExpand
    case afterExpand
    
    mutating func toggle() {
        self = self == .beforeExpand ? .afterExpand : .beforeExpand
    }
    
    var moreText: String {
        switch self {
        case .afterExpand:
            return "접기"
        case .beforeExpand:
            return "더보기"
        }
    }
    
    var lineLimit: Int? {
        switch self {
        case .beforeExpand:
            return 2
        case .afterExpand:
            return nil
        }
    }
}
