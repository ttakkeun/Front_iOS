//
//  TipsViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import Foundation
import Combine

@Observable
class TipsViewModel {
    // MARK: - State Property
    var isShowFloating: Bool = false
    var isSelectedCategory: ExtendPartItem = .all
    var initialLoading: Bool = true
    
    // MARK: - Property
    var tipsResponse: [TipGenerateResponse] = []
    
    // MARK: - Tips Page Property
    var fetchingTips: Bool = false
    var canLoadMoreTips: Bool = true
    var tipsPage: Int = 0
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
    /// 팁 좋아요 액션
    /// - Parameter tipID: 팁 아이디
    func toggleLike(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isLike.toggle()
            
            sendLikeStatusToServer(tipID: tipID)
        }
    }
    
    /// 팁 북마크 액션
    /// - Parameter tipID: 팁 아이디
    func toggleBookMark(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isScrap.toggle()
         
            sendBookMarkStatusToServer(tipID: tipID)
        }
    }
    
    private func refreshAction(refresh: Bool) {
        if refresh {
            self.tipsPage = 0
            self.tipsResponse.removeAll()
            canLoadMoreTips = true
        }
    }
    
    private func getTipsData(_ responseData: [TipGenerateResponse]) {
        let newTips = responseData
        if !newTips.isEmpty {
            self.tipsResponse.append(contentsOf: newTips)
            self.tipsPage += 1
            self.canLoadMoreTips = true
        } else {
            self.canLoadMoreTips = false
        }
        
        self.initialLoading = false
    }
    
    func startNewBaseFunc() {
        self.tipsPage = 0
        self.canLoadMoreTips = true
        self.tipsResponse.removeAll()
        self.initialLoading = true
    }
    
    func startNewAllTipsRequest() {
        startNewBaseFunc()
        getTipsAll(page: self.tipsPage)
    }
    
    func startNewBestTipsRequest() {
        startNewBaseFunc()
        getTipsBest()
    }
    
    func startNewCategorTipsRequest(part: PartItem) {
        startNewBaseFunc()
        getTipsCategory(category: part.rawValue, page: self.tipsPage)
    }
    
    // MARK: - Tip Like/Scrap API
    
    private func sendLikeStatusToServer(tipID: Int) {
        container.useCaseProvider.tipUseCase.executePatchLikeTip(tipId: tipID)
            .validateResult()
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
    
    // MARK: - Tip API
    /// 모든 팁 조회
    /// - Parameters:
    ///   - page: 페이지 값
    ///   - refresh: 리프레시 값
    public func getTipsAll(page: Int, refresh: Bool = false) {
        guard !fetchingTips && canLoadMoreTips else { return }
        refreshAction(refresh: refresh)
        fetchingTips = true
        
        container.useCaseProvider.tipUseCase.executeGetTipsAllData(page: page)
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.fetchingTips = false }
                
                switch completion {
                case .finished:
                    print("GetTipsAll Completed")
                case .failure(let failure):
                    print("GetTipsAll Failure: \(failure)")
                    canLoadMoreTips = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                getTipsData(responseData)
            })
            .store(in: &cancellables)
    }
    
    /// 베스트 팁 조회
    /// - Parameter refresh: 새로 고침
    public func getTipsBest(refresh: Bool = false) {
        guard !fetchingTips && canLoadMoreTips else { return }
        refreshAction(refresh: refresh)
        fetchingTips = true
        
        container.useCaseProvider.tipUseCase.executeGetTipsBestData()
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.fetchingTips = false }
                
                switch completion {
                case .finished:
                    print("getTipsBest Completed")
                case .failure(let failure):
                    print("getTipsBest Failure: \(failure)")
                    canLoadMoreTips = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                getTipsData(responseData)
            })
            .store(in: &cancellables)
    }
    
    /// 팁 카테고리 조회
    /// - Parameters:
    ///   - category: 카테고리
    ///   - page: 페이지
    ///   - refresh: 새로고침
    public func getTipsCategory(category: PartItem.RawValue, page: Int, refresh: Bool = false) {
        guard !fetchingTips && canLoadMoreTips else { return }
        refreshAction(refresh: refresh)
        fetchingTips = true
        
        container.useCaseProvider.tipUseCase.executeGetTipsPartData(cateogry: category, page: page)
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.fetchingTips = false }
                
                switch completion {
                case .finished:
                    print("getTipsCategory Completed")
                case .failure(let failure):
                    print("getTipsAll Failure: \(failure)")
                    canLoadMoreTips = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                getTipsData(responseData)
            })
            .store(in: &cancellables)
    }
}
