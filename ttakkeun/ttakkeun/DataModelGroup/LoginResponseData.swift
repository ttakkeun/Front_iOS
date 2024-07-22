//
//  LoginData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/10/24.
//

import Foundation

/// 로그인 ResponseData, 로그인 시 받게 되는 리스폰스 데이터
struct LoginResponseData: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: LoginResponseDetailData
}

struct LoginResponseDetailData: Codable {
    var accessToken: String
    var refreshToken: String
}
