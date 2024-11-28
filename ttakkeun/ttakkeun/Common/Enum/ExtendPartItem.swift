//
//  ExtendPartItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation
import SwiftUI

enum ExtendPartItem: CaseIterable, Hashable {
    case all
    case best
    case etc
    case part(PartItem)
    
    static var allCases: [ExtendPartItem] {
        return [.all] + PartItem.allCases.map { .part($0) }
    }
    
    static var orderedCases: [ExtendPartItem] {
        return [.all, .best] + PartItem.allCases.map { .part($0) }
    }
    
    static var floatingCases: [ExtendPartItem] {
        return [.etc] + PartItem.allCases.map { .part($0) }
    }
    
    func toKorean() -> String {
        switch self {
        case .all:
            return "전체"
        case .best:
            return "BEST"
        case .etc:
            return "기타"
        case .part(let partItem):
            return partItem.toKorean()
        }
    }
}
