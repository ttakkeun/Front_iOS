//
//  TokenResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation

/// 리프레시 토큰, 리프레시 갱신 시 받게되는 리스폰스 데이터
struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
