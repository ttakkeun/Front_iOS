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
    
    @Published var journalListData: JournalListResponseData? /* 일지 리스트 목록 조회 API */
    @Published var checkJournalQnAResponseData: CheckJournalQnAResponseData? /* 진단서 상세 내용 데이터 */
    @Published var diagnosisData: DiagnosisData? /* 진단 결과 상세 내용 출력 */
    @Published var selectedCnt: Int = 0 /* 일지 선택 갯수 */
    @Published var isSelectionMode: Bool = false
    @Published var selectedItem: Set<Int> = [] /* 선택된 아이템 목록 */
    @Published var selectCategory: PartItem = .ear/* 버튼 컨트롤러 카테고리 변경*/ {
        didSet {
            resetData()
        }
    }
    @Published var currentPage: Int = 0
    @Published var isLastPage: Bool = false // 마지막 페이지 확인
    @Published var isLoadingDiag: Bool = false
    @Published var resultId: Int = 0
    
    private let provider: MoyaProvider<JournalAPITarget>
    let petId: Int
    let container: DIContainer
    
    // MARK: - Init
    init(
        provider: MoyaProvider<JournalAPITarget> = APIManager.shared.createProvider(for: JournalAPITarget.self),
        petId: Int,
        container: DIContainer
    ) {
        self.provider = provider
        self.petId = petId
        self.container = container
    }
    
    // MARK: - 일지 목록 조회 API
    
    /// 일지 목록 조회 함수
    /// - Parameters:
    ///   - petId: 일지 조회 시 사용되는 펫 아이디
    ///   - category: 일지 조회 시 사용되는 카테고리
    public func getJournalList(page: Int) {
        
        provider.request(.getJournalList(petID: self.petId, category: selectCategory.rawValue, page: page)) { [weak self] result in
            
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
                let decodedData = try JSONDecoder().decode(ResponseData<JournalListResponseData>.self, from: response.data)
                if decodedData.isSuccess {
                    if let newRecords = decodedData.result?.recordList, !newRecords.isEmpty {
                        if currentPage == 0 {
                            self.journalListData = decodedData.result
                        } else {
                            self.journalListData?.recordList.append(contentsOf: newRecords)
                        }
                    } else {
                        isLastPage = true
                    }
                } else {
                    print("일지 목록 조회 네트워크 오류: \(decodedData.message)")
                }
            } catch {
                print("일지 목록 조회 디코더 에러: \(error)")
            }
        }
    
    // MARK: - 일지 삭제 API
    
    /// 일지 삭제 API
    /// - Parameter journalID: 선택한 일지 ID
    private func deleteJournalList(journalID: Int) async {
        provider.request(.deleteJournalList(journalID: journalID)) { [weak self] result in
            switch result {
            case .success(let response):
                if let jsonString = String(data: response.data, encoding: .utf8) {
                           print("Received JSON: \(jsonString)")
                       }
                
                do {
                    let decodeData = try JSONDecoder().decode(ResponseData<DiagnosisDelete>.self, from: response.data)
                    if decodeData.isSuccess {
                        self?.removeDeletedJournalFromList(journalID: journalID)
                    } else {
                        print("삭제 못함: \(decodeData.message)")
                    }
                } catch {
                    print("일지 삭제 디코더 에러: \(error)")
                }
            case .failure(let error):
                print("일지 삭제 네트워크 오류 : \(error)")
            }
        }
    }
    
    private func removeDeletedJournalFromList(journalID: Int) {
        if var journalList = journalListData?.recordList {
            journalList.removeAll { $0.recordID == journalID }
            journalListData?.recordList = journalList
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
    
    /// 전체 선택 취소 버튼 액션
    public func clearSelection() async {
        selectedItem.removeAll()
        selectedCnt = 0
    }
    
    // MARK: - Paging
    
    /// 데이터를 초기화하고 첫 페이지 데이터를 로드
       private func resetData() {
           journalListData = nil
           selectedItem.removeAll()
           selectedCnt = 0
           currentPage = 0
           isLastPage = false
           getJournalList(page: currentPage)
       }
    
    // MARK: - 진단하기
    
    func createDiagPayload() -> CreateDiag {
           let recordID = selectedItem.map { RecordID(record_id: $0) }
           return CreateDiag(pet_id: petId, records: recordID)
       }
    
    public func makeDiag(completion: @escaping (Bool) -> Void) {
        self.isLoadingDiag = true
        
        provider.request(.makeDiagnosis(data: createDiagPayload())) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerMakeDiag(response: response, completion: completion)
            case .failure(let error):
                self?.isLoadingDiag = false
                print("진단 생성 네트워크 에러:\(error)")
            }
        }
    }
    
    private func handlerMakeDiag(response: Response, completion: @escaping (Bool) -> Void) {
        
        
        if let jsonString = String(data: response.data, encoding: .utf8) {
                   print("Received JSON: \(jsonString)")
               }
        
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<DiagResult>.self, from: response.data)
            if decodedData.isSuccess {
                if let data = decodedData.result?.products, let resultId = decodedData.result?.result_id {
                    patchDiagnosis(resultId: resultId, products: data, completion: completion)
                    self.resultId = resultId
                }
            }
        } catch {
            print("진단 생성 디코더 에러")
            self.isLoadingDiag = false
        }
    }
    
    // MARK: - NaverShopping
    
    
    private func patchDiagnosis(resultId: Int, products: [String], completion: @escaping (Bool) -> Void) {
        provider.request(.updateContents(resultId: resultId, query: products)) { result in
            switch result {
            case .success(let reponse):
                
                if let jsonString = String(data: reponse.data, encoding: .utf8) {
                           print("Received JSON: \(jsonString)")
                       }
                
                
                do {
                    let decodedData = try JSONDecoder().decode(ResponseData<topProducts>.self, from: reponse.data)
                    if decodedData.isSuccess {
                        if let data = decodedData.result {
                            print("진단 결과 상품 매칭 성공: \(data)")
                            completion(true)
                        }
                    }
                } catch {
                    print("진단 결과 디코더 에러 :\(error)")
                    self.isLoadingDiag = false
                    completion(false)
                }
            case .failure(let error):
                print("진단 결과 네트워크 에러: \(error)")
                self.isLoadingDiag = false
                completion(false)
            }
        }
    }
    
    // MARK: - 진단서 상세 내용 조회
    public func getDetailQnA(recordId: Int, completion: @escaping(Bool) -> Void)  {
        provider.request(.getDetailJournalQnA(petId: self.petId, recordId: recordId)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerDetailQnA(response: response)
                completion(true)
            case .failure(let error):
                print("QnA 상세 조회 네트워크 에러: \(error)")
                completion(false)
            }
        }
    }
    
    /// QnA 상세 조회 핸들러
    /// - Parameter response: Response 값
    private func handlerDetailQnA(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<CheckJournalQnAResponseData>.self, from: response.data)
            if decodedData.isSuccess {
                DispatchQueue.main.async {
                    self.checkJournalQnAResponseData = decodedData.result
                }
            } else {
                print("QnA 상세 조회 실패: \(decodedData.message)")
            }
        } catch {
            print("QnA 상세 조회 디코더 에러: \(error)")
        }
    }
    
    //MARK: - 진단 결과 상세 내용 조회
    
    public func getDiagDetail(completion: @escaping (Bool) -> Void) {
        provider.request(.getResultDiag(resultId: self.resultId)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerDetail(response: response, completion: completion)
            case .failure(let error):
                print("진단 결과 네트워크 에러: \(error)")
            }
        }
    }
    
    private func handlerDetail(response: Response, completion: @escaping (Bool) -> Void) {
        
        if let jsonString = String(data: response.data, encoding: .utf8) {
                   print("Received JSON: \(jsonString)")
               }
        
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<DiagnosisData>.self, from: response.data)
            if decodedData.isSuccess {
                self.diagnosisData = decodedData.result
                completion(true)
            }
        } catch {
            print("진단 결과 디코더 에러: \(error)")
            self.isLoadingDiag = false
            completion(false)
        }
    }
    
    
    // MARK: -Navigation
    
    public func goToMakeDiagnosis() {
        container.navigationRouter.push(to: .createDiagnosis(petId: petId))
    }
}
