//
//  MakeProfileViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya
import PhotosUI

@Observable
class MakeProfileViewModel {
    
    // MARK: - StateProperty
    var showingVarietySearch = false
    var showImagePickerPresented: Bool = false
    var isLoading: Bool = false
    
    // MARK: - FieldProperty
    var isProfileCompleted: Bool = false
    var isNameFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    var isTypeFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    var isVarietyFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    var isBirthFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    var isNeutralizationFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    // MARK: - Property
    var searchVariety: String = ""
    var filteredDogVarieties: [PetVarietyData] {
        if searchVariety.isEmpty {
            return PetVarietyData.allCases.filter { $0.isDog}
        } else {
            return PetVarietyData.allCases.filter { $0.isDog && $0.rawValue.contains(searchVariety) }
        }
    }
    var filteredCatVarieties: [PetVarietyData] {
        if searchVariety.isEmpty {
            return PetVarietyData.allCases.filter { $0.isCat}
        } else {
            return PetVarietyData.allCases.filter { $0.isCat && $0.rawValue.contains(searchVariety) }
        }
    }
    var requestData: PetInfo = PetInfo(name: "", type: nil, variety: "", birth: "", neutralization: nil)
    
    var selectedItem: PhotosPickerItem?
    var selectedImage: UIImage?
  
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer
    ) {
        self.container = container
    }
    
    // MARK: - Method
    
    private func checkFilledStates() {
        isProfileCompleted = isNameFieldFilled && isTypeFieldFilled && isVarietyFieldFilled && isBirthFieldFilled && isNeutralizationFieldFilled
    }
    
    public func loadImage(_ item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            }
        } catch {
            print("이미지 로드 실패", error.localizedDescription)
        }
    }
}

// MARK: - API Method

extension MakeProfileViewModel {
    
    public func makePetProfile(completion: (() -> Void)? = nil) {
        isLoading = true
        
        container.useCaseProvider.petProfileUseCase.executeMakePetProfile(petInfo: requestData)
            .tryMap { responseData -> ResponseData<MakePetProfileResponse> in
                if !responseData.isSuccess {
                    self.isLoading = false
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("MakeProfileServerResponse: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completionStatus in
                
                switch completionStatus {
                case .finished:
                    print("PetProfile Make Complete")
                case .failure(let failure):
                    print("PetProfile Make Failure: \(failure)")
                }
            }, receiveValue: { [weak self] petProfileResponse in
                guard let self = self else { return }
                
                if let petId = petProfileResponse.result?.petId {
                    self.patchPetProfileImage(petId: petId, completion: completion)
                }
            })
            .store(in: &cancellables)
    }
    // MARK: - patchPetProfileImage
    
    public func patchPetProfileImage(petId: Int, completion: (() -> Void)? = nil) {
        if let selectedImage = selectedImage {
            container.useCaseProvider.petProfileUseCase.executePatchPetProfileImage(petId: petId, image: selectedImage)
                .tryMap { responseData -> ResponseData<PatchPetImageResponse> in
                    if !responseData.isSuccess {
                        throw APIError.serverError(message: responseData.message, code: responseData.code)
                    }
                    
                    guard let _ = responseData.result else {
                        throw APIError.emptyResult
                    }
                    print("server: \(responseData)")
                    return responseData
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completionStatus in
                    guard let self = self else { return }
                    
                    self.isLoading = false
                    
                    switch completionStatus {
                    case .finished:
                        print("Patch PetProfile Image Complete")
                        completion?() // 성공 시 completion 호출
                        self.container.navigationRouter.pop()
                    case .failure(let failure):
                        print("Patch PetProfile Image Failure: \(failure)")
                    }
                }, receiveValue: { patchPetProfileResponse in
                    print("펫 이미지 생성: \(patchPetProfileResponse)")
                })
                .store(in: &cancellables)
        } else {
            completion?()
        }
    }
}
