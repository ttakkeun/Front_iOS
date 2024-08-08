//
//  DiagnosisViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import Foundation
import Moya

@MainActor
class DiagnosisViewModel: ObservableObject {
    
    @Published var journalListData: JournalListData?
    @Published var page: Int = 0
    private let provider: MoyaProvider<JournalAPITarget>
    
    init(
        provider: MoyaProvider<JournalAPITarget> = APIManager.shared.testProvider(for: JournalAPITarget.self)
    ) {
        self.provider = provider
    }
    
    // MARK: - 일지 목록 조회 API
    
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
}
