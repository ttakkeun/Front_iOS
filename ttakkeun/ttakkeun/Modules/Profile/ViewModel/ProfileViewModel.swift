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

class ProfileViewModel: ObservableObject {
    
    let colors: [Color] = [Color.card001, Color.card002, Color.card003, Color.card004, Color.card005, Color.mainPrimary]
    var usedColor: [Color] = []
    @Published var backgroudColor: Color = .white
    
    @Published var isLastedCard: Bool = true
    @Published var titleName: String = ""
    @Published var petProfileResponse: PetProfileResponse?
    @Published var isLoading: Bool = true
    
    @Published var showFullScreen: Bool = false
    
    let container: DIContainer
    private var cancellalbes = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func updateBackgroundColor() {
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
        }
    }
}

// MARK: - GetPetProfile

extension ProfileViewModel {
    public func getPetProfile() {
        isLoading = true
        
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
