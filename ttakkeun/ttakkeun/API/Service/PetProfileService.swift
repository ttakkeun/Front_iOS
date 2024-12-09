//
//  PetProfileService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class PetProfileService: PetProfileServiceProtocol {
    
    private let provider: MoyaProvider<PetAPITarget>
    
    init(provider: MoyaProvider<PetAPITarget> = APIManager.shared.createProvider(for: PetAPITarget.self)) {
        self.provider = provider
    }
    
    // 펫 프로파일 생성
    func makePetProfileData(petInfo: PetInfo) -> AnyPublisher<ResponseData<MakePetProfileResponse>, MoyaError> {
        return provider.requestPublisher(.makePetProfile(petInfo: petInfo))
            .map(ResponseData<MakePetProfileResponse>.self)
            .eraseToAnyPublisher()
    }
    
    // 펫 프로필 이미지 등록
    func patchPetProfileImageData(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError> {
        return provider.requestPublisher(.patchPetProfileImage(petId: petId, image: image))
            .map(ResponseData<PatchPetImageResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getPetProfileData() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError> {
        return provider.requestPublisher(.getPetProfile)
            .map(ResponseData<PetProfileResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getSpecificPetProfileData(petId: Int) -> AnyPublisher<ResponseData<HomeProfileResponseData>, MoyaError> {
        return provider.requestPublisher(.getSpecificPetProfile(petId: petId))
            .map(ResponseData<HomeProfileResponseData>.self)
            .eraseToAnyPublisher()
    }
    
    func patchPetProfile(petId: Int, petInfo: PetInfo) -> AnyPublisher<ResponseData<EditProfileResponse>, MoyaError> {
        return provider.requestPublisher(.patchPetProfile(petId: petId, petInfo: petInfo))
            .map(ResponseData<EditProfileResponse>.self)
            .eraseToAnyPublisher()
    }
}
