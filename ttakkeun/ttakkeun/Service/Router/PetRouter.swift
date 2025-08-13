//
//  PetAPITarget.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/28/24.
//

import Foundation
import Moya
import SwiftUI

enum PetAPITarget {
    case postGenerateProfile(petInfo: PetInfo) // 반려동물 프로필 추가
    case patchPetProfileImage(petId: Int, image: UIImage) // 반려동물 프로필 이미지 수정
    case patchPetProfile(petId: Int, petInfo: PetInfo) // 반려동물 프로필 수정
    case getSpecificPetProfile(petId: Int) // 특정 반려동물 프로필 조회(홈탭)
    case deletePetProfile(petId: Int) // 반려동물 프로필 삭제
    case getPetProfile // 프로필 뷰 전체 조회
}

extension PetAPITarget: APITargetType {
    var path: String {
        switch self {
        case .postGenerateProfile:
            return "/api/pet-profile/add"
        case .patchPetProfileImage(let petId, _):
            return "/api/pet-profile/\(petId)/image"
        case .patchPetProfile(let petId, _):
            return "/api/pet-profile/edit/\(petId)"
        case .getSpecificPetProfile(let petId):
            return "/api/pet-profile/\(petId)"
        case .deletePetProfile(let petId):
            return "/api/pet-profile/\(petId)"
        case .getPetProfile:
            return "/api/pet-profile/select"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPetProfile, .getSpecificPetProfile:
            return .get
        case .postGenerateProfile:
            return .post
        case .patchPetProfile, .patchPetProfileImage:
            return .patch
        case .deletePetProfile:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getPetProfile, .getSpecificPetProfile, .deletePetProfile:
            return .requestPlain
        case .postGenerateProfile(let petInfo), .patchPetProfile(_, let petInfo):
            return .requestJSONEncodable(petInfo)
        case .patchPetProfileImage(_, let image):
            let multipartData: [MultipartFormData] = image
                .jpegData(compressionQuality: 0.5)
                .map {
                    [MultipartFormData(
                        provider: .data($0),
                        name: "multipartFile",
                        fileName: "multipartFile.jpeg",
                        mimeType: "multipartFile/jpeg"
                    )]
                } ?? []
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .patchPetProfileImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
