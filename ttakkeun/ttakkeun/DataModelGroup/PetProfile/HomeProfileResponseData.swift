//
//  HomeProfileData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import Foundation

/// 홈탭 - 프로필 카드 데이터
/// 홈탭 - 프로필 카드 전면부, 후면부 사용 데이터
struct HomeProfileResponseData: Codable {
    let name: String
    let image: String
    let type: ProfileType
    let variety: String
    let birth: String
    let neutralization: Bool
}
