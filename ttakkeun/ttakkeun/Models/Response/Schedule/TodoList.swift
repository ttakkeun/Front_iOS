//
//  TodoList.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation

struct TodoList: Codable, Hashable, Identifiable {
    var id = UUID()
    var todoID: Int
    var todoName: String
    var todoStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case todoID = "todoId"
        case todoName = "todoName"
        case todoStatus = "todoStatus"
    }
}
