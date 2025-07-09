//
//  ProfileViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya

@Observable
class ProfileViewModel {
    // MARK: - Property
    let colors: [Color] = [Color.card001, Color.card002, Color.card003, Color.card004, Color.card005, Color.mainPrimary]
    var usedColor: [Color] = []
    var backgroudColor: Color = .white
    var petProfileResponse: PetProfileResponse? = .init(result: [
        .init(petId: 01, name: "테스트1", type: .cat, birth: "222222"),
        .init(petId: 02, name: "테스트2", type: .dog, birth: "222222"),
        .init(petId: 03, name: "테스트3", type: .cat, birth: "222222"),
        .init(petId: 04, name: "테스트4", type: .cat, birth: "222222"),
        .init(petId: 05, name: "테스트5", type: .cat, birth: "222222"),
        .init(petId: 06, name: "테스트6", type: .cat, birth: "222222"),
    ])
    
    // MARK: - StateProperty
    var isLastedCard: Bool = true
    var isLoading: Bool = false
    var showFullScreen: Bool = false
    var titleName: String = ""
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellalbes = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Method
    public func updateBackgroundColor() async {
        if usedColor.count == colors.count {
            usedColor.removeAll()
        }
        
        var newColor: Color
        
        repeat {
            newColor = colors.randomElement()!
        } while usedColor.contains(newColor)
                    
        usedColor.append(newColor)
        withAnimation(.easeInOut(duration: 0.5)) {
        self.backgroudColor = newColor
            print(backgroudColor)
        }
    }
}

// MARK: - GetPetProfile

extension ProfileViewModel {
    public func getPetProfile() {
        isLoading = true
        defer { isLoading = false }
        
        container.useCaseProvider.petProfileUseCase.executegetPetProfile()
            .tryMap { responseData -> ResponseData<PetProfileResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("getProfileServerResponse: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    print("Get PetProfile Complete")
                case .failure(let failure):
                    print("Get PetProfile Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.petProfileResponse = responseData.result
            })
            .store(in: &cancellalbes)
    }
}
