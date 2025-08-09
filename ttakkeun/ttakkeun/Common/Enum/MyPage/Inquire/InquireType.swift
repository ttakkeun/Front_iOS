//
//  InquireType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import Foundation

enum InquireType: String, Codable, CaseIterable {
    case SERVICE
    case AD
    case PARTNERSHIP
    
    var text: String {
        switch self {
        case .SERVICE:
            return "서비스 이용 문의"
        case .AD:
            return "광고 문의"
        case .PARTNERSHIP:
            return "제후 문의"
        }
    }
    
    var param: InquireType {
        switch self {
        case .SERVICE:
            return .SERVICE
        case .AD:
            return .AD
        case .PARTNERSHIP:
            return .PARTNERSHIP
        }
    }
}
