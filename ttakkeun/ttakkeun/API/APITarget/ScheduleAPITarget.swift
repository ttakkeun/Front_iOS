//
//  ScheduleAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya

/// 일정 관련 API 타켓
enum ScheduleAPITarget {
    case getCompleteRate(petId: Int) // 일정 완수율 조회
    case getCalendar(petId: Int, todoDateRequest: TodoDateRequest) // TODO 일정 조회 API
    case patchTodoCheck(todoId: Int) // 투두 체크/취소
    case makeTodoContents(todoData: MakeTodoRequest)
}

extension ScheduleAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getCompleteRate:
            return "/api/todos/completion-rate"
        case .getCalendar(_, let todoDate):
            return "/api/calendar/\(todoDate.year)/\(todoDate.month)/\(todoDate.date)"
        case .patchTodoCheck(let todoId):
            return "/api/todos/\(todoId)/check"
        case .makeTodoContents:
            return "/api/todos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCalendar, .getCompleteRate:
            return .get
        case .patchTodoCheck:
            return .patch
        case .makeTodoContents:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCompleteRate(let id), .getCalendar(let id, _):
            return .requestParameters(parameters: ["petId": id], encoding: URLEncoding.default)
        case .patchTodoCheck:
            return .requestPlain
        case .makeTodoContents(let todoData):
            return .requestJSONEncodable(todoData)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
