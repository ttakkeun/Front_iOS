//
//  QnaTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI

class QnaTipsViewModel: ObservableObject {
    @Published var tips: [QnaTipsData] = [
        QnaTipsData(category: .ear, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 10),
        QnaTipsData(category: .eye, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 20),
        QnaTipsData(category: .eye, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 30),
        QnaTipsData(category: .ear, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 20),
        QnaTipsData(category: .hair, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 200),
        QnaTipsData(category: .tooth, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 20),
        QnaTipsData(category: .tooth, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 220),
        QnaTipsData(category: .ear, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 20),
        QnaTipsData(category: .claw, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 204),
        QnaTipsData(category: .claw, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 202),
        QnaTipsData(category: .claw, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 201),
        QnaTipsData(category: .tooth, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 20),
        QnaTipsData(category: .tooth, title: "털 안꼬이게 빗는 법 꿀팁공유", content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라", userName: "한지강", elapsedTime: 140, heartNumber: 20)
        
    ]
    @Published var selectedCategory: TipsCategorySegment = .best
    
    
    /// 전체, 인기 세그먼트 분류하기 위한 필터
    public var filteredTips: [QnaTipsData] {
        switch selectedCategory {
        case .all:
            return tips.sorted { $0.elapsedTime < $1.elapsedTime }
        case .best:
            return tips.sorted { $0.heartNumber ?? 0 > $1.heartNumber ?? 0 }
        default:
            return tips.filter { $0.category.rawValue == selectedCategory.rawValue }
        }
    }
    
    
    /*get하는 함수 가져와야지*/
    
    
}


/// 팁화면에 대한 카테고리들
enum TipsCategorySegment: String, Codable, CaseIterable {
    case all = "ALL"
    case best = "BEST"
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case tooth = "TOOTH"
    case etc = "ETC"
    
    /// 부위 항목 서버에서 영어로 돌려받는다. 그 결과를 뷰에 보이기 위해 한글로 전환
       /// - Returns: 번역된 한글 값 전달
       func toKorean() -> String {
           switch self {
           case .all:
               return "전체"
           case .best:
               return "BEST"
           case .ear:
               return "귀"
           case .eye:
               return "눈"
           case .hair:
               return "털"
           case .claw:
               return "발톱"
           case .tooth:
               return "이빨"
           case .etc:
               return "기타"
           }
    }
}


