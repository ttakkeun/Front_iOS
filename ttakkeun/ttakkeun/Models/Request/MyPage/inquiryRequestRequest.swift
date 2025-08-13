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
    var inquiryType: InquireType
}
