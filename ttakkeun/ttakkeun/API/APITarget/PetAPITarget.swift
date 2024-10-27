//
//  PetAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/28/24.
//

import Foundation
import Moya

enum PetAPITarget {
    case getPetProfile
    case makePetProfile(petInfo: PetInfo)
}

extension PetAPITarget: APITargetType {
    var path: String {
        switch self {
        case .getPetProfile:
            return "/api/pet-profile/select"
        case .makePetProfile:
            return "/api/pet-profile/add"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPetProfile:
            return .get
        case .makePetProfile:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPetProfile:
            return .requestPlain
        case .makePetProfile(let petInfo):
            return .requestJSONEncodable(petInfo)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
