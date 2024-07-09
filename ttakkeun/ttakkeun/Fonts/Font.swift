//
//  Font.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import SwiftUI

extension Font {
    enum Suit {
        case light
        case bold
        case extraBold
        case extraLight
        case heavy
        case medium
        case regular
        case semibold
        case thin
        
        var value: String {
            switch self {
            case .regular:
                return "SUIT-Regular"
            case .thin:
                return "SUIT-Thin"
            case .extraLight:
                return "SUIT-ExtraLight"
            case .light:
                return "SUIT-Light"
            case .medium:
                return "SUIT-Medium"
            case .semibold:
                return "SUIT-SemiBold"
            case .bold:
                return "SUIT-Bold"
            case .extraBold:
                return "SUIT-ExtraBold"
            case .heavy:
                return "SUIT-Heavy"
            }
        }
    }
    
    enum Santokki {
        case regular
        
        var value: String {
            switch self {
            case .regular:
                return "HSSanTokki2.0-Regular"
            }
        }
    }
    
    static func suit(type: Suit, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static func santokki(type: Santokki, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
}
