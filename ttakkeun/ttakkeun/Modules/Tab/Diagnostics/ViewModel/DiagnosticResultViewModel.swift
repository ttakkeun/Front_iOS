//
//  DiagnosticResultViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation
import Combine
import CombineMoya

@Observable
class DiagnosticResultViewModel {
    
    var diagnosticResolutionData: DiagnosticResolutionResponse? = .init(id: 0, score: 75, detailValue: "으아아으아아으아아으아아으아아", afterCare: "으아아으아아으아아으아아으아아으아아으아아으아아으아아", products: [
        .init(title: "아껴주다 저자극 천연 복실복실 고양이 샴푸", image: "ss", lprice: 13000, brand: "쿠팡"),
        .init(title: "아껴주다 저자극 천연 복실복실 고양이 샴푸", image: "ss", lprice: 14000, brand: "쿠팡"),
        .init(title: "아껴주다 저자극 천연 복실복실 고양이 샴푸", image: "ss", lprice: 16000, brand: "쿠팡"),
        .init(title: "아껴주다 저자극 천연 복실복실 고양이 샴푸", image: "ss", lprice: 13000, brand: "쿠팡"),
        .init(title: "아껴주다 저자극 천연 복실복실 고양이 샴푸", image: "ss", lprice: 17000, brand: "쿠팡")
    ])
     var diagResultListResponse: [diagDetailData] = []
    
     var isShowDetailDiag: Bool = false
     var selectedDiagId: Int? = nil
    
     var isFetching: Bool = false
     var canLoadMore: Bool = true
     var currentPage: Int = 0
    
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
    
    public func getDiagResultList(category: PartItem.RawValue, page: Int, refresh: Bool = false) {
        
        guard !isFetching, canLoadMore || refresh else { return }
        
        if refresh {
            currentPage = 0
            diagResultListResponse.removeAll()
            canLoadMore = true
        }
        
        isFetching = true
        
        container.useCaseProvider.journalUseCase.executeGetDiagList(petId: UserState.shared.getPetId(), category: category, page: page)
            .tryMap { responseData -> ResponseData<DiagResultListResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("✅ getDiagLit: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                isFetching = false
                
                switch completion {
                case .finished:
                    print("✅ getDiagLit Completed")
                case .failure(let failure):
                    print("❌ getDiagLit Failure: \(failure)")
                    canLoadMore = false
                }
                
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let newRecords = responseData.result?.diagnoses, !newRecords.isEmpty {
                    self.diagResultListResponse.append(contentsOf: newRecords)
                    self.currentPage += 1
                    canLoadMore = true
                } else {
                    canLoadMore = false
                }
            })
            .store(in: &cancellables)
    }
}
