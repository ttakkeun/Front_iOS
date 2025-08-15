//
//  MypageInquireDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation

struct MypageInquireRequest: Codable {
    var contents: String
    var email: String
    var inquiryType: InquireType
}
