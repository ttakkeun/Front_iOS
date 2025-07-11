//
//  HomeProfileCardViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

@Observable
class HomeProfileCardViewModel {
    // MARK: - StateProperty
    var isShowFront: Bool = true
    var profileIsLoading: Bool = true
    
    // MARK: - Property
    var profileData: HomeProfileResponseData?
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Method
    public func goToEditPetProfile() {
        container.navigationRouter.push(to: .editPetProfile(editPetInfo: returnEditProfile(), image: profileData?.image ?? ""))
    }
    
    private func returnEditProfile() -> PetInfo {
        guard let profileData = profileData else {
            print("프로필 데이터 없음")
            return PetInfo(name: "",
                           type: .dog,
                           variety: "",
                           birth: "",
                           neutralization: false)
        }

        return PetInfo(name: profileData.name,
                       type: profileData.type,
                       variety: profileData.variety,
                       birth: profileData.birth,
                       neutralization: profileData.neutralization)
    }
}

// MARK: - HomeProfile API
extension HomeProfileCardViewModel {
    public func getSpecificProfile() {
        profileIsLoading = true
        
        container.useCaseProvider.petProfileUseCase.executeSpecificPetProfile(petId: UserState.shared.getPetId())
            .tryMap { responseData -> ResponseData<HomeProfileResponseData> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("HomeSpecificGetServer: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.profileIsLoading = false
                
                switch completion {
                case .finished:
                    print("Home Get Profile Completed")
                case .failure(let failure):
                    print("Home Get Profile Failed: \(failure)")
                }
            }, receiveValue: { [weak self] profileData in
                guard let self = self else { return }
                self.profileData = profileData.result
            })
            .store(in: &cancellables)
    }
}
