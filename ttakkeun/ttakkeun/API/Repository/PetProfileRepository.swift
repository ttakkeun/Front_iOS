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
    
    func patchPetProfile(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError> {
        return petProfileService.patchPetProfileImageData(petId: petId, image: image)
    }
    
    func getPetProfile() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError> {
        return petProfileService.getPetProfileData()
    }
}
