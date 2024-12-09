//
//  EditProfileViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya

class EditProfileViewModel: MakeProfileViewModel {
    
    init(
        container: DIContainer,
        editPetInfo: PetInfo,
        image: String
    ) {
        self.editPetInfo = editPetInfo
        self.imageUrl = image
        super.init(container: container)
    }
    
    @Published var imageUrl: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    @Published var editPetInfo: PetInfo
}

extension EditProfileViewModel {
    public func patchPetProfile() {
        container.useCaseProvider.petProfileUseCase.excutePatchPetProfile(petId: UserState.shared.getPetId(), PetInfo: editPetInfo)
            .tryMap { responseData -> ResponseData<EditProfileResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("Patch PetProfile Server: \(responseData)")
                return responseData
            }
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
                print("펫 프로필 수정 데이터: \(String(describing: responseData.result))")
            })
            .store(in: &cancellables)
    }
}
