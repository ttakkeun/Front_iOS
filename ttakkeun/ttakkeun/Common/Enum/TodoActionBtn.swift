//
//  TodoActionBtn.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation
import SwiftUI

enum TodoActionBtn: String, CaseIterable {
    case againTomorrow = "내일 또 하기"
    case anotherDay = "다른 날 또 하기"
    case replaceTheDate = " 날짜 바꾸기"
    
    func caseIcon() -> Image {
        switch self {
        case .againTomorrow:
            Icon.againIcon.image
        case .anotherDay:
            Icon.anotherIcon.image
        case .replaceTheDate:
            Icon.replaceIcon.image
        }
    }
}
