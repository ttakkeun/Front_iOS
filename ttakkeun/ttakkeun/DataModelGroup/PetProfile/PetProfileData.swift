//
//  PetProfileData.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/14/24.
//

import Foundation

///  프로필 선택 뷰의 데이터
struct PetProfileData: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: [PetProfileResponseData]?
}

struct PetProfileResponseData: Codable, Hashable {
    var pet_id: Int
    var name: String
    var image: String
    var type: ProfileType
    var birth: String
}

