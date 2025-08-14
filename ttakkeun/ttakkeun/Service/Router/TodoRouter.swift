//
//  ScheduleAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya

/// 일정 관련 API 타켓
enum TodoRouter {
    case postGenerateTodo(todoData: TodoGenerateRequest) // 투두 생성
    case postRepeatTodo(todoId: Int) // 투두 내일 또 하기
    case postAnotherDay(todoId: Int, newDate: TodoAnotherDayRequest) // 투두 다른 날 또 하기
    case deleteTodo(todoId: Int) // 투두 삭제
    case patchTodoName(todoId: Int, toodName: TodoPatchRequest) // 투두 수정
    case patchTodoTransferTomorrow(todoId: Int) // 투두 내일하기
    case patchTodoCheck(todoId: Int) // 투두 체크/취소
    case patchTodoTransferAnotherDay(todoId: Int, newDate: TodoAnotherDayRequest) // 투두 날짜 바꾸기
    case getCompleteRate(petId: Int) // 일정 완수율 조회
    case getCalendar(petId: Int, todoDateRequest: TodoCalendarRequest) // TODO 일정 조회 API
}


extension TodoRouter: APITargetType {
    
    var path: String {
        switch self {
        case .postGenerateTodo:
            return "/api/todos"
        case .postRepeatTodo(let todoId):
            return "/api/todos/\(todoId)/repeat-tomorrow"
        case .postAnotherDay(let todoId, _):
            return "/api/todos/\(todoId)/repeat-another-day"
        case .deleteTodo(let todoId):
            return "/api/todos/\(todoId)"
        case .patchTodoName(let todoId, _):
            return "/api/todos/\(todoId)"
        case .patchTodoTransferTomorrow(let todoId):
            return "/api/todos/\(todoId)/do-tomorrow"
        case .patchTodoCheck(let todoId):
            return "/api/todos/\(todoId)/check"
        case .patchTodoTransferAnotherDay(let todoId, _):
            return "/api/todos/\(todoId)/do-tomorrow"
        case .getCompleteRate:
            return "/api/todos/completion-rate"
        case .getCalendar(_, let todoDate):
            return "/api/calendar/\(todoDate.year)/\(todoDate.month)/\(todoDate.date)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCalendar, .getCompleteRate:
            return .get
        case .patchTodoCheck, .patchTodoName, .patchTodoTransferTomorrow, .patchTodoTransferAnotherDay:
            return .patch
        case .postGenerateTodo, .postRepeatTodo, .postAnotherDay:
            return .post
        case .deleteTodo:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postGenerateTodo(let todoData):
            return .requestJSONEncodable(todoData)
        case .postRepeatTodo:
            return .requestPlain
        case .postAnotherDay(_, let newDate):
            return .requestJSONEncodable(newDate)
        case .deleteTodo:
            return .requestPlain
        case .patchTodoName(_, let todoName):
            return .requestJSONEncodable(todoName)
        case .patchTodoTransferTomorrow:
            return .requestPlain
        case .patchTodoCheck:
            return .requestPlain
        case .patchTodoTransferAnotherDay(_, let newDate):
            return .requestJSONEncodable(newDate)
        case .getCompleteRate(let id), .getCalendar(let id, _):
            return .requestParameters(parameters: ["petId": id], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
