//
//  RegistJournalViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import Foundation
import Moya

class RegistJournalViewModel: ObservableObject {
    
    @Published var inputData: RegistJournalData?
    @Published var currentPage: Int = 1
    private let provider: MoyaProvider<JournalAPITarget>
    
    
    // MARK: - Init
    init(provider: MoyaProvider<JournalAPITarget> = APIManager.shared.testProvider(for: JournalAPITarget.self)) {
        self.provider = provider
    }
    
    // MARK: - API Function
    
    public func postInputData() {
        
        guard let data = self.inputData else { return }
        
        provider.request(.registJournal(data: data)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.responsePostData(response: response)
            case .failure(let error):
                print("일정 생성 데이터 네트워크 에러: \(error)")
            }
        }
    }
    
    private func responsePostData(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(RegistJournalResponseData.self, from: response.data)
            print("일정 생성 데이터 디코더 완료 : \(decodedData)")
        } catch {
            print("일정 생성 데이터 디코더 에러 : \(error)")
        }
    }
    
}
