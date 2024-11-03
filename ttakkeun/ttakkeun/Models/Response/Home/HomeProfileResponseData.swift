//
//  HomeProfileResponeData.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import Foundation


struct HomeProfileResponseData: Codable {
    let name: String
    let image: String
    let type: ProfileType
    let variety: String
    let birth: String
    let neutralization: String
    
    enum CodingKeys: String, CodingKey {
        case name = "petName"
        case image = "petImageUrl"
        case type = "petType"
        case variety = "petVariety"
        case birth
        case neutralization
    }
}
