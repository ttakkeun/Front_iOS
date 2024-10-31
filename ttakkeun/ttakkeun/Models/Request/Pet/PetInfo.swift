//
//  PetInfo.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/28/24.
//

import Foundation

struct PetInfo: Codable {
    var name: String
    var type: ProfileType
    var variety: String
    var birth: String
    var neutralization: Bool
}
