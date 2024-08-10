//
//  DiagnosisViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import Foundation
import Moya

@MainActor
class JournalListViewModel: ObservableObject {
    
    @Published var journalListData: JournalListData? /* 일지 리스트 목록 조회 API */
    @Published var page: Int = 0 /* 일지 목록 조회 페이징 */
    @Published var selectedCnt: Int = 20 /* 일지 선택 갯수 */
    @Published var isSelectionMode: Bool = false
    @Published var selectedItem: Set<Int> = [] /* 선택된 아이템 목록 */
    
    private let provider: MoyaProvider<JournalAPITarget>
    
    // MARK: - Init
    init(
        provider: MoyaProvider<JournalAPITarget> = APIManager.shared.testProvider(for: JournalAPITarget.self)
    ) {
        self.provider = provider
    }
    
    // MARK: - 일지 목록 조회 API
    
    /// 일지 목록 조회 함수
    /// - Parameters:
    ///   - petId: 일지 조회 시 사용되는 펫 아이디
    ///   - category: 일지 조회 시 사용되는 카테고리
    public func getJournalList(petId: Int, category: PartItem) async {
        provider.request(.getJournalList(petID: petId, category: category, page: self.page)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerGetJournalList(response: response)
            case .failure(let error):
                print("일지 목록 조회 네트워크 에러: \(error)")
            }
        }
    }
    
    /// 일지 조회 핸들러
    /// - Parameter response: 일지 조회 response
    private func handlerGetJournalList(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(JournalListData.self, from: response.data)
            DispatchQueue.main.async {
                self.journalListData = decodedData
            }
        } catch {
            print("일지 목록 조회 디코더 에러: \(error)")
        }
    }
    
    // MARK: - 일지 삭제 API
    
    /// 일지 삭제 API
    /// - Parameter journalID: 선택한 일지 ID
    private func deleteJournalList(journalID: Int) async {
        provider.request(.deleteJournalList(journalID: journalID)) { result in
            switch result {
            case .success(let response):
                print("일지 삭제 성공: \(response)")
            case .failure(let error):
                print("일지 삭제 네트워크 오류 : \(error)")
            }
        }
    }
    
    /// 반복문을 사용하여 일지 데이터 삭제
    public func deleteSelecttedJournalList() async {
        for journalID in selectedItem {
            await deleteJournalList(journalID: journalID)
        }
        await clearSelection()
    }
    
    // MARK: - 일지 선택 Function
    
    /// 선택버튼 누를 시 아이템 카운트 및 담기
    /// - Parameter index: 일지 데이터 생성 index
    public func toggleSelection(for index: Int) async {
        if selectedItem.contains(index) {
            selectedItem.remove(index)
        } else {
            selectedItem.insert(index)
        }
        selectedCnt = selectedItem.count
    }
    
    /// 전체 선택 취소 버튼 액션
    public func clearSelection() async {
        selectedItem.removeAll()
        selectedCnt = 0
    }
}
