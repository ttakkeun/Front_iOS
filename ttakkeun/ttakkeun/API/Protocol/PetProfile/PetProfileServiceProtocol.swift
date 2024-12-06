//
//  PetProfileService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Foundation
import Combine
import Moya
import SwiftUI

protocol PetProfileServiceProtocol {
    func makePetProfileData(petInfo: PetInfo) -> AnyPublisher<ResponseData<MakePetProfileResponse>, MoyaError>
    
    func patchPetProfileImageData(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PatchPetImageResponse>, MoyaError>
    
    func getPetProfileData() -> AnyPublisher<ResponseData<PetProfileResponse>, MoyaError>
    
    func getSpecificPetProfileData(petId: Int) -> AnyPublisher<ResponseData<HomeProfileResponseData>, MoyaError>
    
    func patchPetProfile(petId: Int, petInfo: PetInfo) -> AnyPublisher<ResponseData<EditProfileResponse>, MoyaError>
}
