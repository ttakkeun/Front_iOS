//
//  JournalListViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

class JournalListViewModel: ObservableObject {
    
    @Published var isSelectionMode: Bool = false
    @Published var selectedCnt: Int = 0
    
    @Published var journalResultData: JournalResultResponse?
    @Published var journalListData: JournalListResponse? // 서버에서 전체 응답 저장
    @Published var recordList: [JournalListItem] = [] // 기록 데이터만 별도로 관리
    
    @Published var selectedItem: Set<Int> = []
    @Published var showDetailJournalList: Bool = false
    
    @Published var showAiDiagnosing: Bool = false
    @Published var showFullScreenAI: Bool = false
    @Published var aiPoint: Int = 10
    
    // MARK: - Calendar
    @Published var isCalendarPresented: Bool = false
    @Published var selectedDate: Date = Date()
    
    // MARK: - DetailJournalView
    @Published var detailDataLoading: Bool = true
    @Published var isShowDetailJournal: Bool = false
    
    // MARK: - MakeDiag
    @Published var isShowMakeDiagLoading: Bool = true
    @Published var diagResultResponse: DiagResultResponse?
    
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
    
    private func makeCreateDiagRequest() -> CreateDiagRequst {
        
        let records = selectedItem.map { RecordID(record_id: $0) }
        
        return CreateDiagRequst(pet_id: UserState.shared.getPetId(),
                                records: records)
    }
}

// MARK: - JournalListAPI

extension JournalListViewModel {
    
    public func getJournalList(category: PartItem.RawValue, page: Int, refresh: Bool = false) {
        
        guard !isFetching, canLoadMore || refresh else { return }
        
        if refresh {
            currentPage = 0
            recordList.removeAll()
            canLoadMore = true
        }
        
        isFetching = true
        
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
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else { return }
            
            isFetching = false
            
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
                canLoadMore = true
            } else {
                self.canLoadMore = false
            }
            
        })
        .store(in: &cancellables)
    }
    
    public func getDetailJournalData(recordId: Int) {
        detailDataLoading = true
        isShowDetailJournal = true
        
        container.useCaseProvider.journalUseCase.executeGetJournalDetailData(petId: UserState.shared.getPetId(), recordId: recordId)
            .tryMap { responseData -> ResponseData<JournalResultResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ DetailJournalData Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                detailDataLoading = false
                
                switch completion {
                case .finished:
                    print("✅  DetailJournaList Get Completed")
                case .failure(let failure):
                    print("❌ DetailJournaList Get Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.journalResultData = responseData.result
            })
            .store(in: &cancellables)
    }
    
    public func deleteJournal(recordIds: Set<Int>, category: PartItem.RawValue) {
        
        let deleteGroup = DispatchGroup()
        
        for recordId in recordIds {
            deleteGroup.enter()
            
            container.useCaseProvider.journalUseCase.executeDeleteJournal(recordId: recordId)
                .tryMap { responseData -> ResponseData<DeleteJournal> in
                    if !responseData.isSuccess {
                        throw APIError.serverError(message: responseData.message, code: responseData.code)
                    }
                    
                    guard let _ = responseData.result else {
                        throw APIError.emptyResult
                    }
                    
                    print("✅ Journal Deleted: \(recordId)")
                    return responseData
                }
                .retry(3)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("✅ Journal Delete Completed: \(recordId)")
                        
                    case .failure(let failure):
                        print("❌ Journal Delete Failure for ID \(recordId): \(failure)")
                    }
                    deleteGroup.leave()
                },
                      receiveValue: { responseData in
                    print("🔵 Delete Response Data: \(responseData)")
                })
                .store(in: &cancellables)
        }
        
        deleteGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.recordList.removeAll()
            self.canLoadMore = true
            self.getJournalList(category: category, page: 0)
        }
    }
    
    public func makeDiag() {
        
        isShowMakeDiagLoading = true
        
        container.useCaseProvider.journalUseCase.executeMakeDiag(data: makeCreateDiagRequest())
            .tryMap { responseData -> ResponseData<DiagResultResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ makeDiag Server: \(String(describing: responseData.result))")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ makeDiag Completed")
                case .failure(let failure):
                    print("❌ makeDiag Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                print("🔵 makeDiag Response Data: \(responseData)")
                if let responseData = responseData.result {
                    self.diagResultResponse = responseData
                    self.updateNaverPatch(data: responseData)
                }
            })
            .store(in: &cancellables)
    }
    
    private func updateNaverPatch(data: DiagResultResponse) {
        
        container.useCaseProvider.journalUseCase.executeUpdateNaver(data: data)
            .tryMap { responseData -> ResponseData<UpdateNaverResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ upDateNaver Server: \(String(describing: responseData.result))")
                return responseData
            }
            .retry(3)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isShowMakeDiagLoading = false
                switch completion {
                case .finished:
                    print("✅ UpdateNaver Completed")
                    
                case .failure(let failure):
                    print("❌ UpdateNaver Failure: \(failure)")
                }
            },
                  receiveValue: { responseData in
                print("🔵 UpadateNaver Data: \(responseData)")
            })
            .store(in: &cancellables)
    }
}
