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
    
    func patchPetProfileImage(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError>
    
    func getPetProfile() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError>
    
    func getSpecificPetProfile(petId: Int) -> AnyPublisher<ResponseData<HomeProfileResponseData>, MoyaError>
    
    func patchPetProfile(petId: Int, petInfo: PetInfo) -> AnyPublisher<ResponseData<EditProfileResponse>, MoyaError>
}
