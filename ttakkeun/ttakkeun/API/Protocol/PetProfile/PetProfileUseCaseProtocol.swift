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

protocol PetProfileUseCaseProtocol {
    func executeMakePetProfile(petInfo: PetInfo) -> AnyPublisher<ResponseData<MakePetProfileResponse>, MoyaError>
    
    func executePatchPetProfileImage(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError>
    
    func executegetPetProfile() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError>
    
    func executeSpecificPetProfile(petId: Int) -> AnyPublisher<ResponseData<HomeProfileResponseData>, MoyaError>
    
    func excutePatchPetProfile(petId: Int, PetInfo: PetInfo) -> AnyPublisher<ResponseData<EditProfileResponse>, MoyaError>
}
