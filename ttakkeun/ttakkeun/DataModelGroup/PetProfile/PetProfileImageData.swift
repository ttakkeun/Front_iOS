//
//  PetProfileImageData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/23/24.
//

import Foundation

/// 펫 프로필 생성 시 지정한 이미지 URL Data 혹은 펫 프로필 사진 편집 Resposne Data
struct PetProfileImageData: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: PetProfileImageResponseData
}

struct PetProfileImageResponseData: Codable {
    var image: String
}
