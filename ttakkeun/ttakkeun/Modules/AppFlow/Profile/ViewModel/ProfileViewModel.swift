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

/// 여러 생성된 프로파일 뷰모델
@Observable
class ProfileViewModel {
    // MARK: - Property
    let colors: [Color] = [Color.card001, Color.card002, Color.card003, Color.card004, Color.card005, Color.mainPrimary]
    var usedColor: [Color] = []
    var backgroudColor: Color = .white
    var petAllResponse: PetAllResponse?
    var titleName: String = ""
    
    // MARK: - StateProperty
    var isLastedCard: Bool = true
    var isLoading: Bool = false
    var showFullScreen: Bool = false
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellalbes = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
    /// 백그라운드 색 변경 함수
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
        }
    }
    
    // MARK: - GetProfile
    /// 로그인한 사용자의 모든 반려 동물 조회
    public func getPetProfile() {
        isLoading = true
        
        container.useCaseProvider.petProfileUseCase.executeGetPetProfile()
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { isLoading = false }
                
                switch completion {
                case .finished:
                    print("Get PetProfile Complete")
                case .failure(let failure):
                    print("Get PetProfile Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.petAllResponse = responseData
            })
            .store(in: &cancellalbes)
    }
}
