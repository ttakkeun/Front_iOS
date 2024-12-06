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
    /// 일정 완수율 조회
    case getCompleteRate(petId: Int)
    /// TODO 일정 조회 API
    case getCalendar(petId: Int, todoDateRequest: TodoDateRequest)
}

extension ScheduleAPITarget: APITargetType {
    
    var path: String {
        switch self {
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
        }
    }
    
    var task: Task {
        switch self {
        case .getCompleteRate(let id), .getCalendar(let id, _):
            return .requestParameters(parameters: ["petId": id], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
