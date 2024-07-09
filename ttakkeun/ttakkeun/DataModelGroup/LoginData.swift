//
//  LoginData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation

struct LoginResponseData: Codable {
    var check: Bool
    var information: LoginResponseDetailData
}

struct LoginResponseDetailData: Codable {
    var accessToken: String
    var refreshToken: String
}
