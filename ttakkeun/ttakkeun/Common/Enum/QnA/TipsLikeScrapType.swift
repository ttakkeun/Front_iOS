//
//  TipsLikeScrapType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/2/25.
//

import Foundation
import SwiftUI

enum TipsLikeScrapType {
    case like(isLike: Bool, action: () -> Void)
    case scrap(isScrap: Bool, action: () -> Void)
    
    var frame: CGSize {
        switch self {
        case .like:
            return .init(width: 19, height: 18)
        case .scrap:
            return .init(width: 15, height: 18)
        }
    }
    
    var foregroundStyle: Color {
        switch self {
        case .like(let isLike, _):
            return isLike ? Color.removeBtn : Color.gray600
        case .scrap(let isScrap, _):
            return isScrap ? Color.card005 : Color.gray600
        }
    }
    
    var action: () -> Void {
        switch self {
        case .like(_, let action):
            return action
        case .scrap(_, let action):
            return action
        }
    }
    
    var image: String {
        switch self {
        case .like(let isLike, _):
            return isLike ? "suit.heart.fill" : "suit.heart"
        case .scrap(let isScrap, _):
            return isScrap ? "bookmark.fill" : "bookmark"
        }
    }
}
