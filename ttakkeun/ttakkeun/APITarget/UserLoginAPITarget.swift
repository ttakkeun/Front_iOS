//
//  UserLoginAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/22/24.
//

import Foundation
import Moya

/// 유저 로그인 API 타겟
enum UserLoginAPITarget {
    case appleLogin(token: String)
}

extension UserLoginAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .appleLogin:
            return "/auth/apple/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .appleLogin(let identyToken):
            return .requestParameters(parameters: ["identityToken": identyToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .appleLogin:
            let json = """
               {
                   "isSuccess": true,
                   "code": "COMMON200",
                   "message": "성공입니다",
                   "result": {
                       "accessToken": "accessToken123456,
                       "refreshToken": "refreshToken1234142"
                   }
               }
               """
            return Data(json.utf8)
        }
    }
}
