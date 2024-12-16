//
//  TodoCheckResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/16/24.
//

import Foundation

struct TodoCheckResponse: Codable {
    var todoId: Int
    var todoDate: String
    var todoStatus: Bool
}
