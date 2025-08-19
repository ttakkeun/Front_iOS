//
//  TodoCompletionViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import Foundation
import Combine
import CombineMoya

@Observable
class ScheduleViewModel {
    // MARK: - StateProperty
    var isLoading: Bool = false
    
    // MARK: - Property
    var completionData: TodoCompletionResponse?
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
        self.getCompletionData()
    }
    
    // MARK: - CompletionAPI
    /// 알정 완수율 조회
    func getCompletionData() {
        isLoading = true
        
        container.useCaseProvider.todoUseCase.executeGetCompleteRate(petId: petId)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoading = false }
                
                switch completion {
                case .finished:
                    print("Apple Login Completed")
                case .failure(let failure):
                    print("Apple Login Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                completionData = responseData
            })
            .store(in: &cancellables)
    }
}
