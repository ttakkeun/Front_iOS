//
//  AgreementData.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/13/24.
//

import SwiftUI

/// 로그인 시 동의항목 데이터
struct AgreementData: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isMandatory: Bool
    var isChecked: Bool = false
    var detailText: String
    
    private enum CodingKeys: String, CodingKey {
        case title, isMandatory, isChecked, detailText
    }
}

