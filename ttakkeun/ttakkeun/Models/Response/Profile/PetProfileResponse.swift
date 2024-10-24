//
//  PetProfileResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation

struct PetProfileResponse: Codable {
    var result: [PetProfileDetail]
}

struct PetProfileDetail: Codable {
    var petId: Int
    var name: String
    var image: String?
    var type: ProfileType
    var birth: String
    
    enum CodingKeys: String, CodingKey {
        case petId
        case name = "petName"
        case image = "petImageUrl"
        case type = "petType"
        case birth
    }
}
