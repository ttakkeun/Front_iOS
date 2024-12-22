//
//  MyInquiryResponse.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/20/24.
//

import Foundation

struct MyInquiryResponse: Equatable, Codable, Hashable {
    var contents: String
    var email: String
    var inquiryType: String
    var imageUrl: [String]
    var created_at: String
}
