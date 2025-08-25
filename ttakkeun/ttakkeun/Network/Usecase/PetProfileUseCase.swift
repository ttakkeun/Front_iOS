//
//  PetProfileUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Combine
import CombineMoya
import Moya
import SwiftUI

class PetProfileUseCase: PetProfileUseCaseProtocol {
    private let service: PetProfileServiceProtocol
    
    init(service: PetProfileServiceProtocol = PetProfileService()) {
        self.service = service
    }
    
    /// 반려동물 프로필 추가
    func executePostGenerateProfile(petInfo: PetInfo) -> AnyPublisher<ResponseData<PetAddResponse>, Moya.MoyaError> {
        return service.postGenerateProfileData(petInfo: petInfo)
    }
    /// 반려동물 프로필 이미지 수정
    func executePatchPetProfileImage(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PetProfileImageResponse>, Moya.MoyaError> {
        return service.patchPetProfileImageData(petId: petId, image: image)
    }
    /// 반려동물 프로필 수정
    func executePatchPetProfile(petId: Int, PetInfo: PetInfo) -> AnyPublisher<ResponseData<PetProfileInfoResponse>, Moya.MoyaError> {
        return service.patchPetProfile(petId: petId, petInfo: PetInfo)
    }
    /// 특정 반려동물 프로필 조회
    func executeSpecificPetProfile(petId: Int) -> AnyPublisher<ResponseData<PetSpacialProfileResponse>, Moya.MoyaError> {
        return service.getSpecificPetProfileData(petId: petId)
    }
    /// 반려동물 프로필 삭제
    func executeDeletePetprofile(petId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, Moya.MoyaError> {
        return service.deletePetprofileData(petId: petId)
    }
    /// 로그인한 사용자의 모든 반려동물 조회
    func executeGetPetProfile() -> AnyPublisher<ResponseData<PetAllResponse>, Moya.MoyaError> {
        return service.getPetProfileData()
    }
    
    
}
