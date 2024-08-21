//
//  ScheduleAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import Foundation
import Moya

/// 일정 관련 API 타켓
enum ScheduleAPITarget {
    /// TODO 일정 조회 API
    case getCalendar(dateData: DateRequestData, petId: Int)
    /// 일정 완수율 조회
    case getCompleteRate(petId: Int)
}

extension ScheduleAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getCalendar(let data, _):
            return "/calendar/\(data.year)/\(data.month)/\(data.date)"
        case .getCompleteRate(let petId):
            return "/todos/completion-rate/\(petId)"
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
        case .getCalendar(_, let id):
            return .requestParameters(parameters: ["petId": id], encoding: URLEncoding.default)
        case .getCompleteRate:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .getCalendar:
            let json = """
{
            "isSuccess": true,
            "code": "200",
            "message": "Inquiry successful",
            "result": {
              "date": "2024-07-28",
              "ear_todos": [
                {
                  "todo_id": 1,
                  "todo_name": "귀 청소하기",
                  "todo_status": false
                },
                {
                  "todo_id": 2,
                  "todo_name": "귀 닦기",
                  "todo_status": false
                },
                {
                  "todo_id": 10,
                  "todo_name": "귀 털정리",
                  "todo_status": false
                }
              ],
              "hair_todos": [
                {
                  "todo_id": 3,
                  "todo_name": "머리 감기기",
                  "todo_status": false
                },
                {
                  "todo_id": 4,
                  "todo_name": "머리 말리기",
                  "todo_status": false
                }
              ],
              "claw_todos": [
                {
                  "todo_id": 4,
                  "todo_name": "Trim claws",
                  "todo_status": false
                }
              ],
              "eye_todos": [
                {
                  "todo_id": 5,
                  "todo_name": "Check for infection",
                  "todo_status": false
                }
              ],
              "tooth_todos": [
                {
                  "todo_id": 6,
                  "todo_name": "Clean teeth",
                  "todo_status": false
                }
              ]
            }
          }
"""
            return Data(json.utf8)
            
            
        case .getCompleteRate:
            let json = """
{
            "isSuccess": true,
            "code": "200",
            "message": "Inquiry successful",
            "result": {
"ear_total": 10,
"ear_completed": 4,
"hair_total": 5,
"hair_completed": 2,
"claw_total": 20,
"claw_completed": 4,
"eye_total": 100,
"eye_completed": 20,
"teeth_total": 1,
"teeth_completed": 1
                }
"""
            return Data(json.utf8)
        }
    }
}
