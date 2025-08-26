//
//  DeleteDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/26/25.
//

import Foundation

struct DeleteRequest: Codable {
    let reasonType: DeleteReasonType
    let customReason: String
    let valid: Bool
}
