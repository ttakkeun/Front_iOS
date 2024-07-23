//
//  CreatePetProfileData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/23/24.
//

import Foundation

/// 펫 프로필 생성 데이터(리퀘스트 바디)
struct CreatePetProfileRequestData: Codable {
    var name: String
    var type: ProfileType
    var birth: String
    var neutralization: Bool
}
