//
//  TipsCategorySegment.swift
//  ttakkeun
//
//  Created by 한지강 on 8/18/24.
//

import Foundation

/// 팁화면에 대한 카테고리들
enum TipsCategorySegment: String, Codable, CaseIterable, Identifiable {
    case all = "ALL"
    case best = "BEST"
    case ear = "EAR"
    case eye = "EYE"
    case hair = "HAIR"
    case claw = "CLAW"
    case tooth = "TOOTH"
    case etc = "ETC"
    
    
    var id: String{ self.rawValue}
    
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
