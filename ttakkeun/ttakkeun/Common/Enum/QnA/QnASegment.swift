//
//  QnASegment.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import Foundation

enum QnASegment: String, SegmentType, CaseIterable {
    case faq = "FAQ"
    case tips = "TIPS"
    
    var title: String {
        self.rawValue
    }
}
