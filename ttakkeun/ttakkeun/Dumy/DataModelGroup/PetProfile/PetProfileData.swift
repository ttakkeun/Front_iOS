//
//  PetProfileData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/14/24.
//

import Foundation

///  프로필 선택 뷰의 데이터
///
struct PetProfileResult: Codable {
    var result: [PetProfileResponseData]
}

struct PetProfileResponseData: Codable, Hashable {
    var pet_id: Int
    var name: String
    var image: String?
    var type: ProfileType
    var birth: String
    
    enum CodingKeys: String, CodingKey {
        case pet_id = "petId"
        case name = "petName"
        case image = "petImageUrl"
        case type = "petType"
        case birth
    }
}

