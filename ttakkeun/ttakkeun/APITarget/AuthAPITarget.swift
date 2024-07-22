//
//  AuthAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/22/24.
//

import Foundation
import Moya

/// 토큰 Refresh 초기화 API 호출
enum AuthAPITarget {
    case refreshToken
}

extension AuthAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "example")!
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/auth/regenerate-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .refreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
