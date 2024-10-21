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
    /// 홈탭뷰에서 사용되는 프로필 카드 뷰 조회
    case getHomeProfile(petId: Int)
    /// 프로필 선택뷰에서 전체 펫 프로필 받아오기
    case getPetProfile
    /// 프로필 선택뷰에서 사용하는 프로필 생성
    case createProfile(data: CreatePetProfileRequestData)
    /// 프로필 생성 시 지정된 사진 전송 및 사진 편집
    case editProfileImage(petId: Int, images: [UIImage])
}

extension PetProfileAPITarget: APITargetType {
    
    var path: String {
        switch self {
        case .getHomeProfile(let petId):
            return "/pet-profile/\(petId)"
        case .getPetProfile:
            return "/pet-profile/select"
        case .createProfile:
            return "/pet-profile/add"
        case .editProfileImage(let petId, _):
            return "/pet-profile/\(petId)/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHomeProfile, .getPetProfile:
            return .get
        case .createProfile:
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
        case .editProfileImage(_, let images):
            var multipartData = [MultipartFormData]()
            
            for(index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.4) {
                    multipartData.append(MultipartFormData(provider: .data(imageData), name: "multipartFile", fileName: "multipartFile\(index).jpeg", mimeType: "multipartFile/jpeg"))
                }
            }
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .editProfileImage:
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
                       "image": "https://i.namu.wiki/i/T3RqYUWiNHd0pePRCSV2hBZJvtA-uZuZ_l9INsFUgad9k0c3S9apiQE8n2dcFeLWwCzCqVBnUA0o6bwD6lJw7HCqvgPj-EIz2iLfr3ZkPIXz5Km0rUxaIPklVYRmHyQvmPlq8xRbeKCIeIGxu6m_KA.webp",
                       "type": "DOG",
                       "variety": "푸들",
                       "birth": "2021-04-22",
                       "neutralization": true
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
                           "image": "https://i.namu.wiki/i/T3RqYUWiNHd0pePRCSV2hBZJvtA-uZuZ_l9INsFUgad9k0c3S9apiQE8n2dcFeLWwCzCqVBnUA0o6bwD6lJw7HCqvgPj-EIz2iLfr3ZkPIXz5Km0rUxaIPklVYRmHyQvmPlq8xRbeKCIeIGxu6m_KA.webp",
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
