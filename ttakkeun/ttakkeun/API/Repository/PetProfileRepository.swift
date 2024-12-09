//
//  PetProfileRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

class PetProfileRepository: PetProfileRepositoryProtocol {
    
    private let petProfileService: PetProfileServiceProtocol
    
    init(petProfileService: PetProfileServiceProtocol = PetProfileService()) {
        self.petProfileService = petProfileService
    }
    
    func makePetProfile(petInfo: PetInfo) -> AnyPublisher<ResponseData<MakePetProfileResponse>, MoyaError> {
        return petProfileService.makePetProfileData(petInfo: petInfo)
    }
    
    func patchPetProfileImage(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError> {
        return petProfileService.patchPetProfileImageData(petId: petId, image: image)
    }
    
    func getPetProfile() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError> {
        return petProfileService.getPetProfileData()
    }
    
    func getSpecificPetProfile(petId: Int) -> AnyPublisher<ResponseData<HomeProfileResponseData>, MoyaError> {
        return petProfileService.getSpecificPetProfileData(petId: petId)
    }
    
    func patchPetProfile(petId: Int, petInfo: PetInfo) -> AnyPublisher<ResponseData<EditProfileResponse>, MoyaError> {
        return petProfileService.patchPetProfile(petId: petId, petInfo: petInfo)
    }
}
