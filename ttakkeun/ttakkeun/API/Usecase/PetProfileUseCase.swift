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
    private let repository: PetProfileRepositoryProtocol
    
    init(repository: PetProfileRepositoryProtocol = PetProfileRepository()) {
        self.repository = repository
    }
    
    func executeMakePetProfile(petInfo: PetInfo) -> AnyPublisher<ResponseData<MakePetProfileResponse>, MoyaError> {
        return repository.makePetProfile(petInfo: petInfo)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePatchPetProfileImage(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError> {
        return repository.patchPetProfile(petId: petId, image: image)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executegetPetProfile() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError> {
        return repository.getPetProfile()
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
