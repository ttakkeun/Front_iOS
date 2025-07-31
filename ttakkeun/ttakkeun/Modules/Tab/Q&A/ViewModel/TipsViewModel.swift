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
    
    var isShowFloating: Bool = false
    
    var isSelectedCategory: ExtendPartItem = .all
    var tipsResponse: [TipsResponse] = []
    
    // MARK: - Tips Page Property
    var fetchingTips: Bool = false
    var canLoadMoreTips: Bool = true
    var initialLoading: Bool = true
    var tipsPage: Int = 0
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func toggleLike(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isLike.toggle()
            
            sendLikeStatusToServer(tipID: tipID)
        }
    }
    
    func toggleBookMark(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isScrap.toggle()
         
            sendBookMarkStatusToServer(tipID: tipID)
        }
    }
    
    private func sendLikeStatusToServer(tipID: Int) {
        container.useCaseProvider.qnaUseCase.executeLikeTips(tipId: tipID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TipsLike Completed")
                case .failure(let failure):
                    print("TipsLike Failed: \(failure)")
                }
            },
                  receiveValue: { responseData in
                print("responseData: \(responseData)")
            })
            .store(in: &cancellables)
    }
    
    private func sendBookMarkStatusToServer(tipID: Int) {
        container.useCaseProvider.qnaUseCase.executeTouchScrap(tipId: tipID)
            .tryMap { responseData -> ResponseData<TouchScrapResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("BookMark Tip sServer: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("BookMark Tip Completed")
                case .failure(let failure):
                    print("BookMark Tip Failed: \(failure)")
                }
            },
                  receiveValue: { responseData in
                if let result = responseData.result {
                    print("BookMark Tip: \(result)")
                }
            })
            .store(in: &cancellables)
    }
}

extension TipsViewModel {
    public func getTipsAll(page: Int, refresh: Bool = false) {
        guard !fetchingTips && canLoadMoreTips else { return }
        
        if refresh {
            self.tipsPage = 0
            self.tipsResponse.removeAll()
            canLoadMoreTips = true
        }
        
        fetchingTips = true
        
        container.useCaseProvider.qnaUseCase.executeGetTipsAll(page: page)
            .tryMap { responseData -> ResponseData<[TipsResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ getTipBest Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                fetchingTips = false
                
                switch completion {
                case .finished:
                    print("✅ getTipsAll Completed")
                case .failure(let failure):
                    print("❌ getTipsAll Failure: \(failure)")
                    canLoadMoreTips = false
                }
                
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let newTips = responseData.result, !newTips.isEmpty {
                    self.tipsResponse.append(contentsOf: newTips)
                    self.tipsPage += 1
                    self.canLoadMoreTips = true
                } else {
                    self.canLoadMoreTips = false
                }
                
                self.initialLoading = false
            })
            .store(in: &cancellables)
    }
    
    public func getTipsBest(refresh: Bool = false) {
        guard !fetchingTips && canLoadMoreTips else { return }
        
        if refresh {
            self.tipsPage = 0
            self.tipsResponse.removeAll()
            canLoadMoreTips = true
        }
        
        fetchingTips = true
        
        container.useCaseProvider.qnaUseCase.executeGetTipsBest()
            .tryMap { responseData -> ResponseData<[TipsResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ getTipsBest Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                fetchingTips = false
                
                switch completion {
                case .finished:
                    print("✅ getTipsBest Completed")
                case .failure(let failure):
                    print("❌ getTipsBest Failure: \(failure)")
                    canLoadMoreTips = false
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let newTips = responseData.result, !newTips.isEmpty {
                    self.tipsResponse.append(contentsOf: newTips)
                    self.tipsPage += 1
                    self.canLoadMoreTips = true
                } else {
                    self.canLoadMoreTips = false
                }
                self.initialLoading = false
            })
            .store(in: &cancellables)
    }
    
    public func getTipsCategory(category: PartItem.RawValue, page: Int, refresh: Bool = false) {
        guard !fetchingTips && canLoadMoreTips else { return }
        
        if refresh {
            self.tipsPage = 0
            self.tipsResponse.removeAll()
            canLoadMoreTips = true
        }
        
        fetchingTips = true
        
        container.useCaseProvider.qnaUseCase.executeGetTips(cateogry: category, page: page)
            .tryMap { responseData -> ResponseData<[TipsResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ getTipCategory Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                fetchingTips = false
                
                switch completion {
                case .finished:
                    print("✅ getTipsCategory Completed")
                case .failure(let failure):
                    print("❌ getTipsAll Failure: \(failure)")
                    canLoadMoreTips = false
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let newTips = responseData.result {
                    if newTips.isEmpty {
                        print("❌ 빈 결과가 반환되었습니다.")
                        self.canLoadMoreTips = false
                    } else {
                        self.tipsResponse.append(contentsOf: newTips)
                        self.tipsPage += 1
                        self.canLoadMoreTips = true
                    }
                } else {
                    self.canLoadMoreTips = false
                }
                self.initialLoading = false
            })
            .store(in: &cancellables)
    }
    
    func startNewBaseFunc() {
        self.tipsPage = 0
        self.canLoadMoreTips = true
        self.tipsResponse = []
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
}
