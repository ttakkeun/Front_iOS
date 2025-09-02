//
//  MyScrapTipsViewModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation
import Combine
import CombineMoya

@Observable
class MyScrapTipsViewModel {
    var myScrapTips: [TipGenerateResponse] = []
    var currentPage = 0
    var canLoadMore = true
    var isFetching = false
    
    var container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    /// 팁 좋아요 액션
    /// - Parameter tipID: 팁 아이디
    func toggleLike(for tipID: Int) {
        if let index = myScrapTips.firstIndex(where: { $0.tipId == tipID }) {
            myScrapTips[index].isLike.toggle()
            
            sendLikeStatusToServer(tipID: tipID)
        }
    }
    
    /// 팁 북마크 액션
    /// - Parameter tipID: 팁 아이디
    func toggleBookMark(for tipID: Int) {
        if let index = myScrapTips.firstIndex(where: { $0.tipId == tipID }) {
            myScrapTips.remove(at: index)
            
            sendBookMarkStatusToServer(tipID: tipID)
        }
    }
    
    private func refreshAction(refresh: Bool) {
        if refresh {
            currentPage = 0
            myScrapTips.removeAll()
            canLoadMore = true
        }
    }
    
    public func getMyScrapTis(page: Int, refresh: Bool = false) {
        guard !isFetching, canLoadMore  || refresh else { return }
        isFetching = true
        refreshAction(refresh: refresh)
        
        container.useCaseProvider.tipUseCase.executeGetMyScrapTipsData(page: page)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isFetching = false }
                
                switch completion {
                case .finished:
                    print("GetMyScrapTips Completed")
                case .failure(let failure):
                    print("GetMyScrapTips Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if !responseData.isEmpty {
                    self.myScrapTips.append(contentsOf: responseData)
                    self.currentPage += 1
                    canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
            })
            .store(in: &cancellables)
    }
    
    private func sendLikeStatusToServer(tipID: Int) {
        container.useCaseProvider.tipUseCase.executePatchLikeTip(tipId: tipID)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TipsLike Completed")
                case .failure(let failure):
                    print("TipsLike Failed: \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("responseData: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
    
    private func sendBookMarkStatusToServer(tipID: Int) {
        container.useCaseProvider.tipUseCase.executePatchTouchScrapData(tipId: tipID)
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("BookMark Tip Completed")
                case .failure(let failure):
                    print("BookMark Tip Failed: \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("BookMark Tip: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
}
