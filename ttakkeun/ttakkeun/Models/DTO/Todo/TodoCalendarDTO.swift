//
//  TodoCalendar.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct TodoCalendarRequest {
    var year: Int /* 년 */
    var month: Int /* 월 */
    var date: Int /* 일 */
}

struct TodoCalendarResponse: Codable {
    var date: String
    var earTodo: [TodoList]
    var hairTodo: [TodoList]
    var clawTodo: [TodoList]
    var eyeTodo: [TodoList]
    var toothTodo: [TodoList]
    
    enum CodingKeys: String, CodingKey {
        case date
        case earTodo = "earTodos"
        case hairTodo = "hairTodos"
        case clawTodo = "clawTodos"
        case eyeTodo = "eyeTodos"
        case toothTodo = "teethTodos"
    }
}

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
