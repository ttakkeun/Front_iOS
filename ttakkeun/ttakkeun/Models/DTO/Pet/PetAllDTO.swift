//
//  PetAllDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct PetAllResponse: Codable, Hashable {
    var result: [PetProfileDetail]
}

struct PetProfileDetail: Codable, Hashable, Identifiable {
    let id: UUID = .init()
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
