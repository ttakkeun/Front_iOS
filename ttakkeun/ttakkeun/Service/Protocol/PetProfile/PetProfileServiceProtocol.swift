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
    func postGenerateProfileData(petInfo: PetInfo) -> AnyPublisher<ResponseData<PetAddResponse>, MoyaError>
    func patchPetProfileImageData(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PetProfileImageResponse>, MoyaError>
    func patchPetProfile(petId: Int, petInfo: PetInfo) -> AnyPublisher<ResponseData<PetProfileInfoResponse>, MoyaError>
    func getSpecificPetProfileData(petId: Int) -> AnyPublisher<ResponseData<PetSpacialProfileResponse>, MoyaError>
    func deletePetprofileData(petId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    func getPetProfileData() -> AnyPublisher<ResponseData<PetAllResponse>, MoyaError>
}
