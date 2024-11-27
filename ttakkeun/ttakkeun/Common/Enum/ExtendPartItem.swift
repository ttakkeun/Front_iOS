//
//  ExtendPartItem.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation

enum ExtendPartItem: CaseIterable, Hashable {
    case all
    case part(PartItem)
    
    static var allCases: [ExtendPartItem] {
        return [.all] + PartItem.allCases.map { .part($0) }
    }
    
    func toKorean() -> String {
        switch self {
        case .all:
            return "전체"
        case .part(let partItem):
            return partItem.toKorean()
        }
    }
}
