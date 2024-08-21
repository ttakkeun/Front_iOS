//
//  CreateProfileViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/30/24.
//

import Foundation
import Moya
import SwiftUI

///포로필 생성뷰 뷰모델
@MainActor
class CreateProfileViewModel: ObservableObject, @preconcurrency ImageHandling {
    
    @Published var requestData: CreatePetProfileRequestData? = CreatePetProfileRequestData(name: "", type: .dog, variety: "", birth: "", neutralization: false)
    @Published var responseData: ResponseData<PetProfileID>?
    @Published var isProfileCompleted: Bool = false
    @Published var isSuccessImage: Bool = false
    
    private let provider: MoyaProvider<PetProfileAPITarget>
    
    init(isProfileCompleted: Bool = false,
         provider: MoyaProvider<PetProfileAPITarget> = APIManager.shared.createProvider(for: PetProfileAPITarget.self)
    ) {
        self.isProfileCompleted = isProfileCompleted
        self.provider = provider
    }
    
    @Published public var isNameFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    @Published public var isTypeFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    @Published public var isVarietyFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    @Published public var isBirthFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    @Published public var isNeutralizationFilled: Bool = false  {
        didSet { checkFilledStates() }
    }
    
    private func checkFilledStates() {
        isProfileCompleted = isNameFilled && isTypeFilled && isVarietyFilled && isNeutralizationFilled
    }
    
    func addImage(_ images: UIImage) {
        if !profileImage.isEmpty {
            profileImage.removeAll()
        }
        profileImage.append(images)
    }
    
    func removeImage(at index: Int) {
        profileImage.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        profileImage
    }
    
    @Published var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int = 0
    
    var profileImage: [UIImage] = []
    
    //MARK: - Profile Image API
    
    func patchPetProfileImage(id: Int, completion: @escaping (Bool) -> Void) {
        provider.request(.editProfileImage(petId: id, images: profileImage)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlePatchProfileImage(response: response, completion: completion)
            case .failure(let error):
                print("프로필 생성 시 사진 전달 네트워크 에러: \(error)")
                completion(false)
            }
        }
    }
    
    private func handlePatchProfileImage(response: Response, completion: @escaping (Bool) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<PetProfileImageResponseData>.self, from: response.data)
            if decodedData.isSuccess {
                print("handlePatchProfileImage - 펫 프로필 사진 전달 성공: \(String(describing: decodedData.result?.petImageUrl))")
                completion(true)
            } else {
                print("handlePatchProfileImage - 사진 전달 실패")
                completion(false)
            }
        } catch {
            print("펫 프로필 사진 디코더 에러: \(error)")
            completion(false)
        }
    }
    
    //MARK: - ProfileData Send API
    public func sendPetProfileData(completion: @escaping (Bool) -> Void) {
        guard let sendData = requestData else {
            print("프로필 생성 전달 데이터 빈 값")
            completion(false)
            return
        }
        provider.request(.createProfile(data: sendData)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerPetProfileData(response: response, completion: completion)
            case .failure(let error):
                print("펫 프로필 데이터 네트워크 에러: \(error)")
                completion(false)
            }
        }
    }
    
    private func handlerPetProfileData(response: Response, completion: @escaping (Bool) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<PetProfileID>.self, from: response.data)
            if decodedData.isSuccess, let id = decodedData.result?.petId {
                print("펫 프로필 데이터 전달 성공, 펫 아이디: \(id)")
                self.patchPetProfileImage(id: id, completion: completion)
            } else {
                print("펫 프로필 데이터 전달 실패: \(decodedData.message)")
                completion(false)
            }
        } catch {
            print("펫 프로필 데이터 디코더 에러: \(error)")
            completion(false)
        }
    }
}
