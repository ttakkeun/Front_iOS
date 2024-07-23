//
//  ProfileAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/22/24.
//

import Foundation
import Moya
import SwiftUI

enum PetProfileAPITarget {
    case getHomeProfile(petId: Int)
    case getPetProfile
    case createProfile(data: CreatePetProfileData)
    case sendProfileImage(petId: Int, images: [UIImage])
    case editProfileImage(petId: Int, images: [UIImage])
}

extension PetProfileAPITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttakkeun.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .getHomeProfile(let petId):
            return "/pet-profile/\(petId)"
        case .getPetProfile:
            return "/pet-profile/select"
        case .createProfile:
            return "/pet-profile/add"
        case .sendProfileImage(let petId, _):
            return "/pet-profile/\(petId)/image-add"
        case .editProfileImage(let petId, _):
            return "/api/pet-profile/\(petId)/image-edit"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHomeProfile, .getPetProfile:
            return .get
        case .createProfile, .sendProfileImage:
            return .post
        case .editProfileImage:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getHomeProfile, .getPetProfile:
            return .requestPlain
        case .createProfile(let data):
            return .requestJSONEncodable(data)
        case .sendProfileImage(let id, let images), .editProfileImage(let id, let images):
            var multipartData = [MultipartFormData]()
            
            for(index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    multipartData.append(MultipartFormData(provider: .data(imageData), name: "file", fileName: "image\(index).jpg", mimeType: "image/jpg"))
                }
            }
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendProfileImage, .editProfileImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getHomeProfile:
            let json = """
               {
                   "isSuccess": true,
                   "code": "200",
                   "message": "Success",
                   "result": {
                       "name": "초코",
                       "image": "https://cdn.imweb.me/upload/S2021010101.jpg",
                       "type": "DOG",
                       "variety": "푸들",
                       "birth": "2021-04-22",
                       "neutralization": true,
                       "created_at": "2024-07-20 13:21:00",
                       "updated_at": "2024-07-22 18:57:00"
                   }
               }
               
               
               """
            return Data(json.utf8)
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
                       }
                   ]
               }
               
               """
            return Data(json.utf8)
            
        case .createProfile:
            let json = """
               {
                   "isSuccess": true,
                   "code": "200",
                   "message": "Success",
                   "result": {
                       "pet_id": 1
                   }
               }

"""
            return Data(json.utf8)
            
            
        case .sendProfileImage:
            let json = """
               {
                   "isSuccess": true,
                   "code": "200",
                   "message": "Success",
                   "result": {
                       "image": "“https://cdn.imweb.me/upload/S20210105812894f0beab9/76a6884f3f9ef.jpg”
                   }
               }

"""
            return Data(json.utf8)
            
        case .editProfileImage:
            let json = """
               {
                   "isSuccess": true,
                   "code": "200",
                   "message": "Success",
                   "result": {
                       "image": "“https://cdn.imweb.me/upload/S20210105812894f0beab9/76a6884f3f9ef.jpg”
                   }
               }

"""
            return Data(json.utf8)
        }
    }
}
