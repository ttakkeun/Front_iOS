//
//  ScheduleAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import Foundation
import Moya

/// 일정관련 API 타겟
//TODO: - 일정 완수율 조회 데이터 필요
enum ScheduleAPITarget {
    /// TODO 일정 조회 API
    case getCalendar(dateData: DateRequestData)
}

extension ScheduleAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getCalendar(let data):
            return "/calendar/\(data.year)/\(data.month)/\(data.date)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCalendar:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCalendar:
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
        }
    }
}
