//
//  TipsBtnType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/7/25.
//

import Foundation
import SwiftUI

enum TipsBtnType {
    case myWriteTips
    case myScrapTips
    
    var text: String {
        switch self {
        case .myWriteTips:
            return "내가 쓴 Tips"
        case .myScrapTips:
            return "내가 스크랩한 Tips"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .myWriteTips:
                .tips
        case .myScrapTips:
                .scrap
        }
    }
    
    var imageSize: CGSize {
        return CGSize(width: 24, height: 24)
    }
    
    var cornerRadius: CGFloat {
        return 10
    }
}
