//
//  MyTipsViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 1/8/25.
//

import Foundation
import Combine
import CombineMoya

@Observable
class MyTipsViewModel {
    // MARK: - StateProperty
    var currentPage: Int = 0
    var canLoadMore: Bool = true
    var isFetching: Bool = false
    
    // MARK: - Property
    var myWriteTips: [TipGenerateResponse] = []
    
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - TipAPI
    public func getMyTips(page: Int) {
        guard !isFetching, canLoadMore else { return }
        isFetching = true
        
        container.useCaseProvider.tipUseCase.executeGetMyWriteTipsData(page: page)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isFetching = false }
                
                switch completion {
                case .finished:
                    print("GetMyWriteTips Completed")
                case .failure(let failure):
                    print("GetMyWriteTips Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if !responseData.isEmpty {
                    self.myWriteTips.append(contentsOf: responseData)
                    self.currentPage += 1
                    canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
            })
            .store(in: &cancellables)
    }
    
    public func deleteTips(tipId: Int) {
        container.useCaseProvider.tipUseCase.executeDeleteMyTipsData(tipId: tipId)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("GetMyScrapTips Completed")
                case .failure(let failure):
                    print("GetMyScrapTips Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let index = myWriteTips.firstIndex(where: { $0.tipId == tipId }) {
                    myWriteTips.remove(at: index)
                }
                
                #if DEBUG
                print("팁 삭제: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
}
