//
//  ScheduleInquiryResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation

struct ScheduleInquiryResponseData: Codable {
    var date: String
    var earTodo: [TodoList]?
    var hairTodo: [TodoList]?
    var clawTodo: [TodoList]?
    var eyeTodo: [TodoList]?
    var toothTodo: [TodoList]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case earTodo = "earTodos"
        case hairTodo = "hairTodos"
        case clawTodo = "clawTodos"
        case eyeTodo = "eyeTodos"
        case toothTodo = "teethTodos"
    }
}
