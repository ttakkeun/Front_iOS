//
//  ProfileAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/22/24.
//

import Foundation
import Moya

enum PetProfileAPITarget {
    case getPetProfile
}

extension PetProfileAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttakkeun.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .getPetProfile:
            return "/pet-profile/select"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPetProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPetProfile:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .getPetProfile:
            let json = """
               {
                   "isSuccess": true,
                   "code": "200",
                   "message": "Success",
                   "result": [
                       {
                           "pet_id": 1,
                           "name": "애깅이",
                           "image": "https://i.namu.wiki/i/Q7sL1U82ugGToy76opQeurJCJvNetQ72cF67vaK7FrG1b8Hm1cCYzhHk3llhUYHkogvJJuf5D4YxpmQpSB7SBqjid3s_b_CJsgo3N52az4QAcKzI7eB7gFcf3c84ip6v-09yuMng3bv8yFavlsRh8Q.webp",
                           "type": "CAT",
                           "birth": "2021-04-22"
                       },
                       {
                           "pet_id": 2,
                           "name": "멍멍이",
                           "image": "https://i.namu.wiki/i/lSIXWXTbk5GRjQRov2qaIaOR7HzJMGN08i2RIwc9bJhIycmGF3UG4Jw0S6_BSu95y90-o5iOXK98R3p1G1ih9ggdJiGJ84dY2j8kYnsg2nznFmLI3BibM-q_dEhabV8YgMQYTxZTMS55AgyNIcrGqQ.webp",
                           "type": "DOG",
                           "birth": "2020-08-15"
                       },
                       {
                           "pet_id": 3,
                           "name": "코코",
                           "image": "https://i.namu.wiki/i/OB_vfg4x6OeFgCzE6Fe_RhVjt2N69xy6h9OfP6PjqC-lWD_Yt6nzwS3Jl3qSgTS7EKXrNJeFNWvayjD7lA59Ug.webp",
                           "type": "CAT",
                           "birth": "2019-11-30"
                       }
                   ]
               }

               """
            return Data(json.utf8)
        }
    }
}
