//
//  CorrectionTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/9/24.
//

import Foundation

/// 투두 수정
struct CorrectionTodo: Codable {
    var category: PartItem
    var name: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case category = "todo_category"
        case name = "todo_name"
        case status = "todo_status"
    }
}
