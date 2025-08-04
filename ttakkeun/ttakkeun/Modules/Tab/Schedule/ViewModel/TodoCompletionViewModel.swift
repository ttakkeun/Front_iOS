//
//  TodoCompletionViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import Foundation
import Combine
import CombineMoya

class TodoCompletionViewModel: ObservableObject {
    @Published var completionData: TodoCompleteResponse?
    @Published var isLoading: Bool = false
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        self.getCompletionData()
    }
    
    func getCompletionData() {
        
        isLoading = true
        
        container.useCaseProvider.scheduleUseCase.executeGetCompleteRate(petId: UserState.shared.getPetId())
            .tryMap { responseData -> ResponseData<TodoCompleteResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("CompletionTodo LoginServer: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                guard let self = self else { return }
                
                isLoading = false
                
                switch completion {
                case .finished:
                    print("Apple Login Completed")
                case .failure(let failure):
                    print("Apple Login Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let responseData = responseData.result {
                    completionData = responseData
                } else {
                    completionData = nil
                }
            })
            .store(in: &cancellables)
    }
}
