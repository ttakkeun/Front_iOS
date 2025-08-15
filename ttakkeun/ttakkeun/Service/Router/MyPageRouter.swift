//
//  MyPageAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/18/24.
//

import Foundation
import Moya

enum MyPageRouter {
    /// 문의하기
    case postGenerateInquire(inquire: MypageInquireRequest, imageData: [Data])
    /// 문의 내용 조회
    case getMyInquire
    /// 유저 닉네임 변경
    case patchEditUserName(newUsername: String)
    /// 유저 정보 조회
    case getUserInfo
}

extension MyPageRouter: APITargetType {
    var path: String {
        switch self {
        case .postGenerateInquire:
            return "/api/inquiry/add"
        case .getMyInquire:
            return "/api/inquiry/myInquiry"
        case .patchEditUserName:
            return "/api/mypage/username"
        case .getUserInfo:
            return "/api/mypage/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postGenerateInquire:
            return .post
        case .getMyInquire:
            return .get
        case .patchEditUserName:
            return .patch
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postGenerateInquire(let inquire, let imageData):
            let formData = inquire.multipartFormParts(jsonFieldName: "inquiryRequestDTO", images: imageData)
            return .uploadMultipart(formData)
        case .patchEditUserName(let newUsername):
            return .requestParameters(parameters: ["newUsername": newUsername], encoding: URLEncoding.default)
        case .getUserInfo, .getMyInquire:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postGenerateInquire:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
