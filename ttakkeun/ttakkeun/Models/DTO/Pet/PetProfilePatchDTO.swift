//
//  PetProfilePatchDTO.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation

struct PetProfileImageResponse: Codable {
    var petImageUrl: String
}

struct PetProfileInfoResponse: Codable {
    let petName: String
    let petType: ProfileType
    let petVariety: String
    let birth: String
    let neutralization: Bool
}
