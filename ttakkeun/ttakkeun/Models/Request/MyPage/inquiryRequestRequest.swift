//
//  inquiryRequestDTO.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/25/24.
//

import Foundation

struct InquiryRequestDTO: Codable {
    var contents: String
    var email: String
    var inquiryType: InquiryType
}


enum InquiryType: String, Codable {
    case SERVICE
    case AD
    case PARTNERSHIP
    
    func toKorean() -> String {
        switch self {
        case .SERVICE:
            return "서비스 이용 문의"
        case .AD:
            return "광고 문의"
        case .PARTNERSHIP:
            return "제후 문의"
        }
    }
}
