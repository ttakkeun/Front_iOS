//
//  ScheduleInquiry.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/27/24.
//

import Foundation

// MARK: - Response
/// 5가지 항목에 대한 투두 결과 response 데이터(현재 날짜만 가져옴)
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

/// 각 부위별 갖게 되는 리스트 항목
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

// MARK: - Request

/// 날짜 조회 리퀘스트 바디
struct DateRequestData: Codable {
    var year: Int /* 년 */
    var month: Int /* 월 */
    var date: Int /* 일 */
}
