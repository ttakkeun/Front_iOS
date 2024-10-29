//
//  AgreementData.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import Foundation
import SwiftUI

/// 로그인 시 동의항목 데이터
struct AgreementData: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isMandatory: Bool
    var isChecked: Bool = false
    var detailText: [SectionData]
    
    private enum CodingKeys: String, CodingKey {
        case title, isMandatory, isChecked, detailText
    }
}

// 각 조항의 제목과 내용을 담는 구조체
struct SectionData: Codable {
    var section: String
    var text: String
}
