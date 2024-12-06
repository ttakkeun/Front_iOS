//
//  EditProfileResponse.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation

struct EditProfileResponse: Codable {
    let petName: String
    let petType: ProfileType
    let petVariety: String
    let birth: String
    let neutralization: Bool
}
