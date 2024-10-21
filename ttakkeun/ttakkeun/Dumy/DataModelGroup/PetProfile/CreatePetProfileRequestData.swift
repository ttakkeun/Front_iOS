//
//  CreatePetProfileData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/23/24.
//

import Foundation

// MARK: - RequestData
/// 펫 프로필 생성 데이터(리퀘스트 바디)
struct CreatePetProfileRequestData: Codable {
    var name: String
    var type: ProfileType
    var variety: String
    var birth: String
    var neutralization: Bool
}

// MARK: - ResponseData
struct PetProfileID: Codable {
    let petId: Int
}
