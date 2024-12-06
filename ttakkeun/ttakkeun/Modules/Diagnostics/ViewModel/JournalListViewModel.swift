//
//  JournalListViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation
import Combine
import CombineMoya

class JournalListViewModel: ObservableObject {
    @Published var isSelectionMode: Bool = false
    @Published var selectedCnt: Int = 0
    
    @Published var journalResultData: JournalResultResponse?
    @Published var journalListData: JournalListResponse? // 서버에서 전체 응답 저장
    @Published var recordList: [JournalListItem] = [] // 기록 데이터만 별도로 관리
    
    @Published var selectedItem: Set<UUID> = []
    @Published var showDetailJournalList: Bool = false
    
    @Published var showAiDiagnosing: Bool = false
    @Published var aiPoint: Int = 10
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Paging
    
    @Published var isFetching: Bool = false
    @Published var currentPage: Int = 1
    @Published var canLoadMore: Bool = true
    @Published var listIsLoading: Bool = true
}

// MARK: - JournalListAPI

extension JournalListViewModel {
    public func getJournalList(category: PartItem.RawValue, page: Int) {
        
        guard !isFetching, canLoadMore else { return }
        
        isFetching = true
        canLoadMore = true
        
        container.useCaseProvider.journalUseCase.executeGetJournalList(
            petId: UserState.shared.getPetId(),
            category: category,
            page: page
        )
        .tryMap { responseData -> ResponseData<JournalListResponse> in
            if !responseData.isSuccess {
                throw APIError.serverError(message: responseData.message, code: responseData.code)
            }
            
            guard let _ = responseData.result else {
                throw APIError.emptyResult
            }
            
            print("JournalList Server : \(responseData)")
            return responseData
        }
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else { return }
            
            isFetching = false
            canLoadMore = false
            
            switch completion {
            case .finished:
                print("JournalList Get Completed")
            case .failure(let failure):
                print("JournalList Get Failure: \(failure)")
                self.canLoadMore = false
            }
        }, receiveValue: { [weak self] responseData in
            guard let self = self else { return }
            
            self.journalListData = responseData.result
            
            if let newRecords = responseData.result?.recordList, !newRecords.isEmpty {
                self.recordList.append(contentsOf: newRecords)
                self.currentPage += 1
            } else {
                self.canLoadMore = false
            }
            
        })
        .store(in: &cancellables)
    }
}
