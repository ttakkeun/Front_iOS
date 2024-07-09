//
//  LoginAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import Moya

enum LoginAPITarget {
    case sendIdentiCode(token: String)
}

extension LoginAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "example")!
    }
    
    var path: String {
        switch self {
        case .sendIdentiCode:
            return "/sendToken"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendIdentiCode:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sendIdentiCode(let token):
            return .requestParameters(parameters: ["Authorization": token], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .sendIdentiCode:
            let json = """
{
    "check": true,
    "information": {
        "accessToken": "1234",
        "refreshToken": "123456"
    }
}
"""
            
            return Data(json.utf8)
        }
    }
}
