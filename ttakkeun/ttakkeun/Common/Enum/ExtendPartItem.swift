//
//  ExtendPartItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation
import SwiftUI

enum ExtendPartItem: CaseIterable, Hashable, Codable, Identifiable, Equatable {
    case all
    case best
    case etc
    case part(PartItem)
    
    var id: String {
        switch self {
        case .all:
            return "all"
        case .best:
            return "best"
        case .etc:
            return "etc"
        case .part(let partItem):
            return "part-\(partItem.rawValue)"
        }
    }
    
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
    
    func beforeToColor() -> Color {
        switch self {
        case .all, .etc:
            return Color.clear
        case .best:
            return Color.primarycolor200
        case .part(let partItem):
            return partItem.toColor()
        }
    }
    
    func afterToColor() -> Color {
        switch self {
        case .all, .etc, .best:
            return Color.clear
        case .part(let partItem):
            return partItem.toAfterColor()
        }
    }
    
    func toPartItemRawValue() -> PartItem.RawValue? {
        switch self {
        case .part(let partItem):
            return partItem.rawValue
        default:
            return nil
        }
    }
}
