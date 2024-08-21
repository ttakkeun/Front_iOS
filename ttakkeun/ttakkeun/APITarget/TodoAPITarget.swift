//
//  TodoAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/9/24.
//

import Foundation
import Moya

enum TodoAPITarget {
    /// Todo 생성
    case createTodo(data: CreateTodoData)
    /// Todo 체크
    case checkTodo(todoID: Int)
    /// Todo 수정
    case todoCorrection(todoID: Int, data: CorrectionTodo)
    /// Todo 삭제
    case todoDelete(todoID: Int)
    /// Todo 내일 또하기
    case todoRepeatTomorrow(todoID: Int)
    /// Todo 다른 날 또 하기
    case todoOtherDay(todoID: Int, otherDay: String)
    /// 다른 날짜 바꾸기
    case todoChangeDay(todoID: Int, changeDay: String)
    /// 내일 하기
    case todoTomorrow(todoID: Int)
}

extension TodoAPITarget: APITargetType {
    var path: String {
        switch self {
        case .createTodo:
            return "/todos"
        case .checkTodo(let id):
            return "/todos/\(id)/check"
        case .todoCorrection(let id, _):
            return "/todos/\(id)"
        case .todoDelete(let id):
            return "/todos/\(id)"
        case .todoRepeatTomorrow(let id):
            return "/todos/\(id)/repeat-tomorrow"
        case .todoOtherDay(let id, _):
            return "/todos/\(id)/repeat-another-day"
        case .todoChangeDay(let id, _):
            return "/todos/\(id)/change-date"
        case .todoTomorrow(let id):
            return "/todos/\(id)/do-tomorrow"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTodo, .todoRepeatTomorrow, .todoOtherDay:
            return .post
        case .checkTodo, .todoCorrection, .todoChangeDay, .todoTomorrow:
            return .patch
        case .todoDelete:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createTodo(let data):
            return .requestJSONEncodable(data)
        case .checkTodo:
            return .requestPlain
        case .todoCorrection(_, let data):
            return .requestJSONEncodable(data)
        case .todoDelete:
            return .requestPlain
        case .todoRepeatTomorrow:
            return .requestPlain
        case .todoOtherDay(_, let data), .todoChangeDay(_, let data):
            return .requestParameters(parameters: ["new_date": data], encoding: JSONEncoding.default)
        case .todoTomorrow:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
           switch self {
           case .createTodo:
               let json = """
               {
                   "title": "Sample Todo",
                   "description": "This is a sample todo description.",
                   "dueDate": "2024-08-22"
               }
               """
               return Data(json.utf8)
           
           case .checkTodo:
               let json = """
               {
                   "todoID": 1,
                   "checked": true
               }
               """
               return Data(json.utf8)
           
           case .todoCorrection:
               let json = """
               {
                   "title": "Updated Todo",
                   "description": "This is an updated todo description.",
                   "dueDate": "2024-08-23"
               }
               """
               return Data(json.utf8)
           
           case .todoDelete:
               let json = """
               {
                   "todoID": 1,
                   "deleted": true
               }
               """
               return Data(json.utf8)
           
           case .todoRepeatTomorrow:
               let json = """
               {
                   "todoID": 1,
                   "repeat": "tomorrow"
               }
               """
               return Data(json.utf8)
           
           case .todoOtherDay:
               let json = """
               {
                   "todoID": 1,
                   "new_date": "2024-08-25"
               }
               """
               return Data(json.utf8)
           
           case .todoChangeDay:
               let json = """
               {
                   "todoID": 1,
                   "new_date": "2024-08-24"
               }
               """
               return Data(json.utf8)
           
           case .todoTomorrow:
               let json = """
               {
                   "todoID": 1,
                   "scheduledForTomorrow": true
               }
               """
               return Data(json.utf8)
           }
       }
    
}
