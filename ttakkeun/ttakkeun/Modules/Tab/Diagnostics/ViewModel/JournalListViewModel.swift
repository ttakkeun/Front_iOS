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
    
    // MARK: - StateProperty
    var showFullScreenAI: Bool = false /* 진단 관련 전체 화면 상태 */
    var showDiagnosedAlert: Bool = false /* 진단 받기 Alert */
    var isShowMakeDiagLoading: Bool = true /* 진단 중 로딩 상태*/ /* 데이터 수집 이후 로딩 끝나도록 하기*/
    var isCalendarPresented: Bool = false /* 날짜 검색 시 캘린더 보기 */
    var isSelectionMode: Bool = false /* 데이터 선택 모드 */
    
    // MARK: - LoadingProperty
    var detailDataLoading: Bool = true
    
    // MARK: - Property
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    var selectedCnt: Int = 0
    var aiPoint: Int = 0
    
    var diagResultResponse: DiagnoseAIResponse?
    var journalResultData: RecordResultResponse?
    var journalListData: RecordListResponse?
    var recordList: [JournalListItem] = []
    var selectedItem: Set<Int> = []
    var selectedDate: Date = Date()
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Paging Property
    var isFetching: Bool = false
    var currentPage: Int = 0
    var canLoadMore: Bool = true
    var listIsLoading: Bool = true
    
    // MARK: - Common
    private func createDiagRequest() -> DiagnoseAIRequest {
        
        let records = selectedItem.map { RecordID(record_id: $0) }
        
        return DiagnoseAIRequest(pet_id: petId,
                                 records: records)
    }
    
    /// 새로 고침 액션
    /// - Parameter refresh: 새로 고침 값
    private func refreshAction(refresh: Bool) {
        if refresh {
            currentPage = 0
            recordList.removeAll()
            canLoadMore = true
        }
    }
    
    // MARK: - Record API
    public func getJournalList(category: PartItem.RawValue, page: Int, refresh: Bool = false) {
        guard !isFetching, canLoadMore || refresh else { return }
        refreshAction(refresh: refresh)
        isFetching = true
        
        container.useCaseProvider.recordUseCase.executeGetJournalList(
            petId: petId,
            category: category,
            page: page
        )
        .validateResult()
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else { return }
            defer { self.isFetching = false }
            
            switch completion {
            case .finished:
                print("JournalList Get Completed")
            case .failure(let failure):
                print("JournalList Get Failure: \(failure)")
                self.canLoadMore = false
            }
        }, receiveValue: { [weak self] responseData in
            guard let self = self else { return }
            let newRecords = responseData.recordList
            
            if !newRecords.isEmpty {
                self.recordList.append(contentsOf: newRecords)
                self.currentPage += 1
                canLoadMore = true
            } else {
                self.canLoadMore = false
            }
        })
        .store(in: &cancellables)
    }
    
    /// 일지 데이터 상세 조회
    /// - Parameter recordId: 일지 Id
    public func getDetailJournalData(recordId: Int) {
        detailDataLoading = true
        
        container.useCaseProvider.recordUseCase.executeGetDetailJournal(petId: petId, recordId: recordId)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.detailDataLoading = false }
                
                switch completion {
                case .finished:
                    print("DetailJournaList Get Completed")
                case .failure(let failure):
                    print("DetailJournaList Get Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.journalResultData = responseData
            })
            .store(in: &cancellables)
    }
    
    /// 일지 검색
    /// - Parameters:
    ///   - category: 검색 카테고리
    ///   - date: 날짜 데이터
    public func searchGetJournal(category: PartItem.RawValue, date: String) {
        container.useCaseProvider.recordUseCase.executeGetSearchJournal(petId: petId, category: category, date: date)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("SearchGetJournalList Completed")
                    
                case .failure(let failure):
                    print("SearchGetJournalList Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.recordList.removeAll()
                self.recordList = responseData.recordList
            })
            .store(in: &cancellables)
    }
    
    /// 일지 삭제
    /// - Parameters:
    ///   - recordIds: 삭제할 아이디 Set
    ///   - category: 일지 카테고리
    public func deleteJournal(recordIds: Set<Int>, category: PartItem.RawValue) {
        guard !recordIds.isEmpty else { return }
        
        let deletePublishers = recordIds.map { recordId in
            container.useCaseProvider.recordUseCase
                .executeDeleteJournal(recordId: recordId)
                .validateResult()
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(deletePublishers)
            .collect()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Delete Journal Completed")
                case .failure(let failure):
                    print("Delete Journal Failure: \(failure)")
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                
                self.recordList.removeAll()
                self.currentPage = 0
                self.canLoadMore = true
                self.getJournalList(category: category, page: 0, refresh: true)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Diag
    /// 일지를 기반으로 진단 파일 생성하기
    public func makeDiag() {
        isShowMakeDiagLoading = true
        
        container.useCaseProvider.diagnoseUseCase.executePostDiagnose(diagnose: createDiagRequest())
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("makeDiag Completed")
                case .failure(let failure):
                    print("makeDiag Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.diagResultResponse = responseData
                self.updateNaverPatch(data: responseData)
                
                #if DEBUG
                print("makeDiag Response Data: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
    
    /// 진단 상품 네이버 업데이트
    /// - Parameter data: 진단 상품 데이터
    private func updateNaverPatch(data: DiagnoseAIResponse) {
        container.useCaseProvider.diagnoseUseCase.executePatchUpdateNaver(diagId: data.resultID, data: .init(products: data.products))
            .validateResult()
            .retry(3)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isShowMakeDiagLoading = false }
                
                switch completion {
                case .finished:
                    print("UpdateNaver Completed")
                case .failure(let failure):
                    print("UpdateNaver Failure: \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("UpadateNaver Data: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
    
    // MARK: - UserPoint
    /// 유저 포인트 조회
    public func getUserPoint() {
        container.useCaseProvider.diagnoseUseCase.executeGetUserPoint()
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("GetUserPoint Completed")
                case .failure(let failure):
                    print("GetUserPoint Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.aiPoint = responseData.point + 1
                UserDefaults.standard.setValue(self.aiPoint, forKey: AppStorageKey.aiCount)
            })
            .store(in: &cancellables)
    }
    
    /// 유저 포인트 감소
    public func patchUserPoint() {
        container.useCaseProvider.diagnoseUseCase.executePatchUserPoint()
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("PatchUserPoint Completed")
                case .failure(let failure):
                    print("PatchUserPoint Failure: \(failure)")
                }
            }, receiveValue: { responseData in
                
                #if DEBUG
                print("현재 유저 포인트: \(responseData.point)")
                #endif
            })
            .store(in: &cancellables)
    }
}
