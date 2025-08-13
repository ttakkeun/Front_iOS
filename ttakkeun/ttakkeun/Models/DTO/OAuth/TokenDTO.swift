//
//  TokenDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

/// 리프레시 토큰, 리프레시 갱신 시 받게되는 리스폰스 데이터
struct TokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
}
