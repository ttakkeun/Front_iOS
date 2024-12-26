//
//  MyPageAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/18/24.
//

import Foundation
import Moya

enum MyPageAPITarget {
    case getUserInfo
    case editUserName(newUsername: String)
    case logout
    case deleteProfile(petId: Int)
    
    case getMyInquire
}

extension MyPageAPITarget: APITargetType {
    var path: String {
        switch self {
        case .getUserInfo:
            return "/api/mypage/info"
        case .editUserName:
            return "/api/mypage/username"
        case .logout:
            return "/api/auth/logout"
        case .deleteProfile(let petId):
            return "/api/pet-profile/\(petId)"
        case .getMyInquire:
            return "/api/inquiry/myInquiry"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .editUserName:
            return .patch
        case .logout:
            return .post
        case .deleteProfile:
            return .delete
        case .getMyInquire:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo, .logout, .deleteProfile, .getMyInquire:
            return .requestPlain
        case .editUserName(let newUsername):
            return .requestParameters(parameters: ["newUsername": newUsername], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
