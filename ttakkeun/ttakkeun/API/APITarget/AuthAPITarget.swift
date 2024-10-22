//
//  AuthAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation
import Moya

enum AuthAPITarget {
    case sendRefreshToken(refreshToken: String)
}

extension AuthAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .sendRefreshToken:
            return "api/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendRefreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendRefreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        
        switch self {
        case .sendRefreshToken(let refresh):
            headers["RefreshToken"] = "Bearer \(refresh)"
        }
        
        return headers
    }
}
