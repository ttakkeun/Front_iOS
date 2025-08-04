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
    case tomorrowDay = "내일 하기"
    case anotherDay = "다른 날짜 또 하기"
    case replaceTheDate = "날짜 바꾸기"
    
    func caseIcon() -> Image {
        switch self {
        case .againTomorrow, .tomorrowDay:
            Image(.againIcon)
        case .anotherDay:
            Image(.anotherIcon)
        case .replaceTheDate:
            Image(.replaceIcon)
        }
    }
    
    static func checkedTask() -> [TodoActionBtn] {
        return [.againTomorrow, .anotherDay, .replaceTheDate]
    }
    
    static func uncheckTask() -> [TodoActionBtn] {
        return [.tomorrowDay, .replaceTheDate]
    }
}
