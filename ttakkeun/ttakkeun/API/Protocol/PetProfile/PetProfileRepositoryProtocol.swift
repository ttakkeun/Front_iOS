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

protocol PetProfileRepositoryProtocol {
    func makePetProfile(petInfo: PetInfo) -> AnyPublisher<ResponseData<MakePetProfileResponse>, MoyaError>
    
    func patchPetProfile(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError>
    
    func getPetProfile() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError>
}
