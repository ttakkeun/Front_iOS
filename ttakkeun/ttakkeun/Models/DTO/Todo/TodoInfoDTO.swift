//
//  TodoInfoDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct TodoInfoResponse: Codable {
    var todoId: Int
    var todoDate: String
    var todoStatus: Bool
}
