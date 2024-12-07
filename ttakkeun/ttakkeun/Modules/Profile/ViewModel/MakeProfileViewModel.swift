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

class MakeProfileViewModel: ObservableObject {
    
    // MARK: - Search
    
    @Published var showingVarietySearch = false
    @Published var searchVariety: String = ""
    @Published var isLoading: Bool = false
    
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
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer
    ) {
        self.container = container
    }
    
    // MARK: - Field
    
    @Published var requestData: PetInfo = PetInfo(name: "", type: nil, variety: "", birth: "", neutralization: nil)
    
    @Published var isProfileCompleted: Bool = false
    
    @Published var isNameFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isTypeFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isVarietyFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isBirthFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isNeutralizationFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    private func checkFilledStates() {
        isProfileCompleted = isNameFieldFilled && isTypeFieldFilled && isVarietyFieldFilled && isBirthFieldFilled && isNeutralizationFieldFilled
    }
    
    
    // MARK: - ImagePicker
    
    var profileImage: [UIImage] = []
    
    @Published var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int = 0
}

extension MakeProfileViewModel: ImageHandling {
    
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
}

    // MARK: - API Method

extension MakeProfileViewModel {
    
    public func makePetProfile() {
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
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    print("PetProfile Make Complete")
                case .failure(let failure):
                    print("PetPRofile Make Failure: \(failure)")
                }
            }, receiveValue: { [weak self] petProfileResponse in
                guard let self = self else { return }
                handleMakePetProfileResponse(petId: petProfileResponse.result?.petId)
                
                if let petId = petProfileResponse.result?.petId {
                    patchPetProfileImage(petId: petId)
                }
            })
            .store(in: &cancellables)
    }
    
    private func handleMakePetProfileResponse(petId: Int?) {
        if let petId = petId {
            print("생성된 펫 id: \(petId)")
        } else {
            print("생성된 펫 id 정보 없음: 0")
        }
    }
    
    // MARK: - patchPetProfileImage
    
    public func patchPetProfileImage(petId: Int) {
        if !getImages().isEmpty {
            container.useCaseProvider.petProfileUseCase.executePatchPetProfileImage(petId: petId, image: getImages()[0])
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
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Patch PetProfile Image Complete")
                        self.container.navigationRouter.pop()
                    case .failure(let failure):
                        print("Patch PetProfile Image Failure: \(failure)")
                    }
                }, receiveValue: { [weak self] patchPetProfileResponse in
                    guard let self = self else { return }
                    handleProfileImageUrlResponse(imageUrl: patchPetProfileResponse.result?.petImageUrl)
                })
                .store(in: &cancellables)
        } else {
            self.container.navigationRouter.pop()
        }
    }
    
    private func handleProfileImageUrlResponse(imageUrl: String?) {
        if let imageUrl = imageUrl {
            print("생성된 펫 이미지 주소: \(imageUrl)")
        } else {
            print("생성된 펫 이미지 정보 없음: 0")
        }
    }
    
}
