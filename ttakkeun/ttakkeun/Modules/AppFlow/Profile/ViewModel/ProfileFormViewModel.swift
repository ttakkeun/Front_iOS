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

/// 프로파일 편집 및 생성 전용 뷰모델
@Observable
class ProfileFormViewModel {
    
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
    var imageURL: String?
    var mode: ProfileMode
  
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(mode: ProfileMode, container: DIContainer) {
        self.mode = mode
        self.container = container
        
        if case let .edit(image, pet) = mode {
            self.requestData = pet
            self.imageURL = image
        }
    }
    // MARK: - Method
    public func checkInEditMode() {
        isNameFieldFilled = !requestData.name.isEmpty
        isTypeFieldFilled = requestData.type != nil
        isVarietyFieldFilled = !requestData.variety.isEmpty
        isBirthFieldFilled = !requestData.birth.isEmpty
        isNeutralizationFieldFilled = requestData.neutralization != nil
    }
    
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
    
    /// 프로필 생성 및 수정 액션
    /// - Parameter completion: 생성 후, 다음 작업
    func submit(completion: @escaping () -> Void) {
        switch mode {
        case .create:
            makePetProfile {
                completion()
            }
        case .edit:
            patchPetProfile()
        }
    }
    
    // MARK: - PetProfileAPI
    /// 펫 프로필 생성
    public func makePetProfile(completion: (() -> Void)? = nil) {
        isLoading = true
        
        container.useCaseProvider.petProfileUseCase.executePostGenerateProfile(petInfo: requestData)
            .validateResult()
            .sink(receiveCompletion: {completionStatus in
                defer { self.isLoading = false }
                switch completionStatus {
                case .finished:
                    print("PetProfile Make Complete")
                case .failure(let failure):
                    print("PetProfile Make Failure: \(failure)")
                }
            }, receiveValue: { [weak self] petProfileResponse in
                guard let self = self else { return }
                self.patchPetProfileImage(petId: petProfileResponse.petId, completion: completion)
            })
            .store(in: &cancellables)
    }
    
    /// 펫 프로필 이미지 수정
    /// - Parameter petId: 펫 아이디
    private func patchPetProfileImage(petId: Int, completion: (() -> Void)? = nil) {
        if let selectedImage = selectedImage {
            container.useCaseProvider.petProfileUseCase.executePatchPetProfileImage(petId: petId, image: selectedImage)
                .validateResult()
                .sink(receiveCompletion: { [weak self] completionStatus in
                    guard let self = self else { return }
                    defer { self.isLoading = false }
                    completion?()
                    
                    switch completionStatus {
                    case .finished:
                        print("Patch PetProfile Image Complete")
                    case .failure(let failure):
                        print("Patch PetProfile Image Failure: \(failure)")
                    }
                }, receiveValue: { patchPetProfileResponse in
                    self.container.navigationRouter.pop()
                    
                    #if DEBUG
                    print("펫 이미지 생성: \(patchPetProfileResponse)")
                    #endif
                })
                .store(in: &cancellables)
        }
    }
    
    // MARK: - EditProfile
    /// 동물 프로필 수정, 홈 화면에서 접근 시 사용
    public func patchPetProfile() {
        let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
        
        container.useCaseProvider.petProfileUseCase.executePatchPetProfile(petId: petId, PetInfo: requestData)
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("Patch Pet Profile Completed")
                    self.patchPetProfileImage(petId: UserState.shared.getPetId())
                case .failure(let failure):
                    print("Patch Pet Profile Failure: \(failure)")
                }
            }, receiveValue: { responseData in
                print("펫 프로필 수정 데이터: \(String(describing: responseData))")
            })
            .store(in: &cancellables)
    }
}
