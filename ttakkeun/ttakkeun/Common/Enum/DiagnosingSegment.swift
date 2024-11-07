//
//  DiagnosingSegment.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation

enum DiagnosingSegment: String, CaseIterable, SegmentType {
    case journalList = "일지목록"
    case diagnosticResults = "진단결과"
    
    var title: String {
        self.rawValue
    }
}
