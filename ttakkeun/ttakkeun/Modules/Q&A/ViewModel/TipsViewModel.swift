//
//  TipsViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import Foundation
import Combine

class TipsViewModel: ObservableObject {
    
    @Published var isShowFloating: Bool = false
    
    @Published var isSelectedCategory: ExtendPartItem = .all
    @Published var tipsResponse: [TipsResponse] = []
    
    // MARK: - Tips Page Property
    @Published var fetchingTips: Bool = false
    @Published var canLoadMoreTips: Bool = true
    @Published var initialLoading: Bool = true
    @Published var tipsPage: Int = 0
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func toggleLike(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isLike.toggle()
            
            sendLikeStatusToServer(tipID: tipID, isLiked: tipsResponse[index].isLike)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error updating like status: \(error)")
                        self.tipsResponse[index].isLike.toggle()
                    }
                } receiveValue: { success in
                    print("Successfully updated like status for \(tipID): \(success)")
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleBookMark(for tipID: Int) {
        if let index = tipsResponse.firstIndex(where: { $0.tipId == tipID }) {
            tipsResponse[index].isScrap.toggle()
            
            sendBookMarkStatusToServer(tipID: tipID, isScrap: tipsResponse[index].isScrap)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error updating like status: \(error)")
                        self.tipsResponse[index].isScrap.toggle()
                    }
                } receiveValue: { success in
                    print("Successfully updated like status for \(tipID): \(success)")
                }
                .store(in: &cancellables)
        }
    }
    
    private func sendLikeStatusToServer(tipID: Int, isLiked: Bool) -> AnyPublisher<Bool, Error> {
        // 서버 요청 시뮬레이션
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success(true)) // 성공 시 true 반환
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func sendBookMarkStatusToServer(tipID: Int, isScrap: Bool) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success(true))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
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
    
    func startNewCategorTipsRequest() {
        startNewBaseFunc()
        
        if let category = isSelectedCategory.toPartItemRawValue() {
            getTipsCategory(category: category, page: self.tipsPage)
        }
    }
}
