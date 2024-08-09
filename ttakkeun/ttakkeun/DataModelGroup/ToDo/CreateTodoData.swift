//
//  CreateTodoData.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/9/24.
//

import Foundation

/// 투두 생성 Request 파라미터
struct CreateTodoData: Codable {
    let category: PartItem
    let todoContent: String
    
    enum CodingKeys: String, CodingKey {
        case category = "todo_category"
        case todoContent = "todo_name"
    }
}
