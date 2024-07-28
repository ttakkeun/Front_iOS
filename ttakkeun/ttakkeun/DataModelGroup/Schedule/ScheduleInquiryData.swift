//
//  ScheduleInquiry.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/27/24.
//

import Foundation

// MARK: - Response

/// 일정 - 캘린더 조회 데이터
struct ScheduleInquiry: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: ScheduleInquiryResponseData
}

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
        case earTodo = "ear_todos"
        case hairTodo = "hair_todos"
        case clawTodo = "claw_todos"
        case eyeTodo = "eye_todos"
        case toothTodo = "tooth_todos"
    }
}

/// 각 부위별 갖게 되는 리스트 항목
struct TodoList: Codable, Hashable {
    var todoID: Int
    var todoName: String
    var todoStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case todoID = "todo_id"
        case todoName = "todo_name"
        case todoStatus = "todo_status"
    }
}

// MARK: - Request

/// 날짜 조회 리퀘스트 바디
struct DateRequestData: Codable {
    var year: Int /* 년 */
    var month: Int /* 월 */
    var date: Int /* 일 */
}
