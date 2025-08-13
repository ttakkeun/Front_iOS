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
    func executePostGenerateProfile(petInfo: PetInfo) -> AnyPublisher<ResponseData<PetAddResponse>, MoyaError>
    func executePatchPetProfileImage(petId: Int, image: UIImage) -> AnyPublisher<ResponseData<PetProfileImageResponse>, MoyaError>
    func executePatchPetProfile(petId: Int, PetInfo: PetInfo) -> AnyPublisher<ResponseData<PetProfileInfoResponse>, MoyaError>
    func executeSpecificPetProfile(petId: Int) -> AnyPublisher<ResponseData<PetSpacialProfileResponse>, MoyaError>
    func executeDeletePetprofile(petId: Int) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    func executeGetPetProfile() -> AnyPublisher<ResponseData<PetAllResponse>, MoyaError>
}
