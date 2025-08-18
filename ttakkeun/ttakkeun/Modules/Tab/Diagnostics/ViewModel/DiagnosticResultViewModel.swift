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
    
    // MARK: - Property
    var diagnosticResolutionData: DiagnoseDetailResponse?
    var diagResultListResponse: [DiagDetailData] = []
    var selectedDiagId: Int? = nil
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    
    // MARK: - StateProperty
    var isShowDetailDiag: Bool = false
    var isFetching: Bool = false
    var canLoadMore: Bool = true
    var currentPage: Int = 0
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
    private func refreshAction(refresh: Bool) {
        if refresh {
            currentPage = 0
            diagResultListResponse.removeAll()
            canLoadMore = true
        }
    }
    
    /// 단일 진단 결과 받아오기
    /// - Parameter diagId: 진단 결과 아이디
    public func getDiagResult(diagId: Int) {
        container.useCaseProvider.diagnoseUseCase.executeGetDetailDiag(diagId: diagId)
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("getDiagResult Completed")
                case .failure(let failure):
                    print("getDiagResult Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.diagnosticResolutionData = responseData
            })
            .store(in: &cancellables)
    }
    
    /// 진단 결과 리스트 가져오기
    /// - Parameters:
    ///   - category: 진단 카테고리
    ///   - page: 진단 페이지
    ///   - refresh: 새로고침 여부
    public func getDiagResultList(category: PartItem.RawValue, page: Int, refresh: Bool = false) {
        guard !isFetching, canLoadMore || refresh else { return }
        isFetching = true
        refreshAction(refresh: refresh)
        
        container.useCaseProvider.diagnoseUseCase.executeGetDiagResultList(petId: petId, category: category, page: page)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isFetching = false }
                
                switch completion {
                case .finished:
                    print("getDiagLit Completed")
                case .failure(let failure):
                    print("getDiagLit Failure: \(failure)")
                    canLoadMore = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                let newRecords = responseData.diagnoses
                if !newRecords.isEmpty {
                    self.diagResultListResponse.append(contentsOf: newRecords)
                    self.currentPage += 1
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
            })
            .store(in: &cancellables)
    }
}
