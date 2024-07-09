//
//  Icon.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import SwiftUI

enum Icon: String {
    case home = "logo"
    case diagnosis = "diagnosis"
    case schedule = "schedule"
    case sugeestion = "sugeestion"
    case qna = "qna"
    
    
    var image: Image {
        return Image(self.rawValue)
    }
    
    func tabItem(for isSelected: Bool) -> Image {
        let iconName = isSelected ? self.clickedIconName : self.rawValue
        return Image(iconName)
    }
    
    private var clickedIconName: String {
        switch self {
        case .home:
            return "clickedHome"
        case .diagnosis:
            return "clickedDiagnosis"
        case .schedule:
            return "clickedSchedule"
        case .sugeestion:
            return "clickedSugeestion"
        case .qna:
            return "clickedQna"
        }
    }
}
