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

class PetProfileService: PetProfileServiceProtocol, BaseAPIService {
    typealias Target = PetAPITarget
    
    let provider: MoyaProvider<PetAPITarget>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<PetAPITarget> = APIManager.shared.createProvider(for: PetAPITarget.self),
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }(),
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func postGenerateProfileData(petInfo: PetInfo) -> AnyPublisher<ResponseData<PetAddResponse>, Moya.MoyaError> {
        request(.postGenerateProfile(petInfo: petInfo))
    }
    
    func patchPetProfileImageData(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PetProfileImageResponse>, Moya.MoyaError> {
        request(.patchPetProfileImage(petId: petId, image: image))
    }
    
    func patchPetProfile(petId: Int, petInfo: PetInfo) -> AnyPublisher<ResponseData<PetProfileInfoResponse>, Moya.MoyaError> {
        request(.patchPetProfile(petId: petId, petInfo: petInfo))
    }
    
    func getSpecificPetProfileData(petId: Int) -> AnyPublisher<ResponseData<PetSpacialProfileResponse>, Moya.MoyaError> {
        request(.getSpecificPetProfile(petId: petId))
    }
    
    func deletePetprofileData(petId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, Moya.MoyaError> {
        request(.deletePetProfile(petId: petId))
    }
    
    func getPetProfileData() -> AnyPublisher<ResponseData<PetAllResponse>, Moya.MoyaError> {
        request(.getPetProfile)
    }
    
}
