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

@Observable
class JournalListViewModel {
    
    var isSelectionMode: Bool = false
    var selectedCnt: Int = 0
    
    var journalResultData: JournalResultResponse?
    var journalListData: JournalListResponse?
    var recordList: [JournalListItem] = [
        .init(recordID: 0, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 1, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 2, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 3, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 4, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 5, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 6, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 7, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 8, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 9, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 10, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 11, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 12, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 13, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 14, recordDate: "2024-12-03", recordTime: "11111"),
        .init(recordID: 15, recordDate: "2024-12-03", recordTime: "11111")
    ]
    
    var selectedItem: Set<Int> = []
    var showDetailJournalList: Bool = false
    
    var showAiDiagnosing: Bool = false
    var showFullScreenAI: Bool = false
    var aiPoint: Int = 0
    
    // MARK: - Calendar
    var isCalendarPresented: Bool = false
    var selectedDate: Date = Date()
    
    // MARK: - DetailJournalView
    var detailDataLoading: Bool = true
    var isShowDetailJournal: Bool = false
    
    // MARK: - MakeDiag
    var isShowMakeDiagLoading: Bool = true
    var diagResultResponse: DiagResultResponse?
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Paging
    
    var isFetching: Bool = false
    var currentPage: Int = 0
    var canLoadMore: Bool = true
    var listIsLoading: Bool = true
    
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
    
    public func getUserPoint() {
        
        container.useCaseProvider.journalUseCase.executeGetUserPoint()
            .tryMap { responseData -> ResponseData<DiagUserPoint> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ GetUserPoint: \(String(describing: responseData.result))")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ GetUserPoint Completed")
                    
                case .failure(let failure):
                    print("❌ GetUserPoint Failure: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let responseData = responseData.result {
                    self.aiPoint = responseData.point + 1
                }
            })
            .store(in: &cancellables)
    }
    
    public func patchUserPoint() {
        
        container.useCaseProvider.journalUseCase.executePatchUserPoint()
            .tryMap { responseData -> ResponseData<DiagUserPoint> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ PatchUserPoint: \(String(describing: responseData.result))")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ PatchUserPoint Completed")
                    
                case .failure(let failure):
                    print("❌ PatchUserPoint Failure: \(failure)")
                }
            },
                  receiveValue: { responseData in
                if let responseData = responseData.result {
                    print("현재 유저 포인트: \(responseData.point)")
                }
            })
            .store(in: &cancellables)
    }
    
    public func searchGetJournal(category: PartItem.RawValue, date: String) {
        container.useCaseProvider.journalUseCase.executeSearchGetJournal(category: category, date: date)
            .tryMap { responseData -> ResponseData<JournalListResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ SearchGetJournalList: \(String(describing: responseData.result))")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ SearchGetJournalList Completed")
                    
                case .failure(let failure):
                    print("❌ SearchGetJournalList Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let responseData = responseData.result {
                    self.recordList.removeAll()
                    self.recordList = responseData.recordList
                }
            })
            .store(in: &cancellables)
    }
    
}
