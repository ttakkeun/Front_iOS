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
    
    enum HSSanTokki2 {
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
    
    static func santokki(type: HSSanTokki2, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - H2
    
    static var H2_semibold: Font {
        return .suit(type: .semibold, size: 24)
    }
    
    static var H2_bold: Font {
        return .suit(type: .bold, size: 24)
    }
    
    // MARK: - H3
    
    static var H3_bold: Font {
        return .suit(type: .bold, size: 20)
    }
    
    static var H3_semiBold: Font {
        return .suit(type: .semibold, size: 20)
    }
    
    // MARK: - H4
    
    static var H4_bold: Font {
        return .suit(type: .bold, size: 16)
    }
    
    static var H4_semibold: Font {
        return .suit(type: .semibold, size: 16)
    }
    
    static var H4_medium: Font {
        return .suit(type: .medium, size: 16)
    }
    
    // MARK: - Body1
    static var Body1_bold: Font {
        return .suit(type: .bold, size: 18)
    }
    
    static var Body1_semibold: Font {
        return .suit(type: .semibold, size: 18)
    }
    
    // MARK: - Body2
    
    static var Body2_bold: Font {
        return .suit(type: .bold, size: 16)
    }
    
    static var Body2_semibold: Font {
        return .suit(type: .semibold, size: 16)
    }
    
    static var Body2_medium: Font {
        return .suit(type: .medium, size: 16)
    }
    
    static var Body2_regular: Font {
        return .suit(type: .regular, size: 16)
    }
    
    // MARK: - Body3
    
    static var Body3_bold: Font {
        return .suit(type: .bold, size: 14)
    }
    
    static var Body3_semibold: Font {
        return .suit(type: .semibold, size: 14)
    }
    
    static var Body3_medium: Font {
        return .suit(type: .medium, size: 14)
    }
    
    static var Body3_regular: Font {
        return .suit(type: .regular, size: 14)
    }
    
    // MARK: - Body4
    
    static var Body4_extrabold: Font {
        return .suit(type: .extraBold, size: 12)
    }
    
    static var Body4_medium: Font {
        return .suit(type: .medium, size: 12)
    }
    
    // MARK: - Body5
    
    static var Body5_semiBold: Font {
        return .suit(type: .semibold, size: 10)
    }
    
    static var Body5_medium: Font {
        return .suit(type: .medium, size: 10)
    }
    
    // MARK: - Detail1
    
    static var Detail1_bold: Font {
        return .suit(type: .bold, size: 10)
    }
    
    static var Detail1_medium: Font {
        return .suit(type: .medium, size: 10)
    }
    
    // MARK: - Detail2
    
    static var Detail2_regular: Font {
        return .suit(type: .regular, size: 8)
    }
}

