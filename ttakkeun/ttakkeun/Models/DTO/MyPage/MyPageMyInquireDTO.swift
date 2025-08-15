//
//  MyPageMyInquireDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct MyPageMyInquireResponse: Equatable, Codable, Hashable, Identifiable {
    var id = UUID()
    var contents: String
    var email: String
    var inquiryType: InquireType
    var imageUrl: [String]
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case contents = "contents"
        case email = "email"
        case inquiryType = "inquiryType"
        case imageUrl = "imageUrl"
        case createdAt = "created_at"
    }
}
