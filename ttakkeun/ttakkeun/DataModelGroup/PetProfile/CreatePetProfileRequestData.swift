//
//  CreatePetProfileData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/23/24.
//

import Foundation

// MARK: - RequestData
/// 펫 프로필 생성 데이터(리퀘스트 바디
struct CreatePetProfileRequestData: Codable {
    var name: String
    var type: ProfileType
    var variety: String
    var birth: String
    var neutralization: Bool
}

// MARK: - ResponseData
struct CreatePetProfileResponseData: Codable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: PetDetailData?
}

struct PetDetailData: Codable {
    let petID: Int
    
    enum CodingKeys: String, CodingKey {
        case petID = "pet_id"
    }
}
