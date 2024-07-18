//
//  LoginData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/10/24.
//

import Foundation


/// 로그인 ResponseData
struct LoginResponseData: Codable {
    var accessToken: String
    var refreshToken: String
}
