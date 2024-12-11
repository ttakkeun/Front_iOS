//
//  DiagnosticResultViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation
import Combine
import CombineMoya

class DiagnosticResultViewModel: ObservableObject {
    
    @Published var diagnosticResolutionData: DiagnosticResolutionResponse?
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func getDiagResult(diagId: Int) {
        container.useCaseProvider.journalUseCase.executeGetDiagResult(diagId: diagId)
            .tryMap { responseData -> ResponseData<DiagnosticResolutionResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("✅ getDiagResult: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ getDiagResult Completed")
                case .failure(let failure):
                    print("❌ getDiagResult Failure: \(failure)")
                }
                
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.diagnosticResolutionData = responseData.result
            })
            .store(in: &cancellables)
    }
}
