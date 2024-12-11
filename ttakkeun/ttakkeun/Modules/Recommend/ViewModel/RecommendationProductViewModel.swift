//
//  RecommendationViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation
import Combine
import CombineMoya

class RecommendationProductViewModel: ObservableObject {
    @Published var selectedCategory: ExtendPartItem = .all
    @Published var aiProducts: [ProductResponse] = []
    @Published var recommendProducts: [ProductResponse] = []
    

    @Published var isLoadingAIProduct: Bool = false
    
    @Published var isLoadingUserProduct: Bool = false
    @Published var canLoadMoarUserProduct: Bool = true
    @Published var userAllisIitialLoading: Bool = true
    
    // MARK:  RankTag
    @Published var isLoadingRankTagProduct: Bool = false
    @Published var canLoadMoreRankTagProduct: Bool = true
    @Published var userRankTagisIitialLoading: Bool = true
    
    @Published var userProductPage: Int = 0
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func goToSearchView() {
        container.navigationRouter.push(to: .productSearch)
    }
}

extension RecommendationProductViewModel {
    func getAIProucts() {
        
        isLoadingAIProduct = true
        
        container.useCaseProvider.productRecommendUseCase.executeGetAIRecommend(petId: UserState.shared.getPetId())
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.message)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ getAIRecommendProducts Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isLoadingAIProduct = false
                
                switch completion {
                case .finished:
                    print("✅ getAIRecommendProducts Server Completed")
                case .failure(let failure):
                    print("❌ getAIRecommendProducts Server Failure \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self else { return }
                if let data = responseData.result, !data.isEmpty {
                    self.aiProducts = data
                }
            })
            .store(in: &cancellables)
    }
    
    func getUserRecommendAll(page: Int) {
    
        guard !isLoadingUserProduct && canLoadMoarUserProduct else { return }
        
        isLoadingUserProduct = true
        
        container.useCaseProvider.productRecommendUseCase.executeGetRankProduct(pageNum: page)
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.message)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ getUserRecommendProductsAll Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                isLoadingUserProduct = false
                
                switch completion {
                case .finished:
                    print("✅ getUserRecommendProductsAll Server Completed")
                case .failure(let failure):
                    print("❌ getUserRecommendProductsAll Server Failure \(failure)")
                    canLoadMoarUserProduct = false
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let data = responseData.result, !data.isEmpty {
                    self.recommendProducts.append(contentsOf: data)
                    self.userProductPage += 1
                    self.canLoadMoarUserProduct = true
                } else {
                    self.canLoadMoarUserProduct = false
                }
                
                self.userAllisIitialLoading = false
            })
            .store(in: &cancellables)
    }
    
    func startNewUserProductAll() {
        self.userProductPage = 0
        self.canLoadMoarUserProduct = true
        self.recommendProducts = []
        self.userAllisIitialLoading = true
        getUserRecommendAll(page: userProductPage)
    }
    
    func getUserRecommendTag(tag: PartItem.RawValue, page: Int) {
        guard !isLoadingRankTagProduct && canLoadMoreRankTagProduct else { return }
        
        isLoadingRankTagProduct = true
        
        container.useCaseProvider.productRecommendUseCase.executeGetRankProductTag(tag: tag, page: page)
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.message)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ getUserRecommendProductsTag Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                isLoadingRankTagProduct = false
                
                switch completion {
                case .finished:
                    print("✅ getUserRecommendProductsTag Server Completed")
                case .failure(let failure):
                    print("❌ getUserRecommendProductsTag Server Failure \(failure)")
                    canLoadMoreRankTagProduct = false
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let data = responseData.result, !data.isEmpty {
                    self.recommendProducts.append(contentsOf: data)
                    self.userProductPage += 1
                    canLoadMoreRankTagProduct = true
                } else {
                    self.canLoadMoarUserProduct = false
                }
                self.userRankTagisIitialLoading = false
            })
            .store(in: &cancellables)
    }
    
    func startNewRankTagProducts() {
        self.userProductPage = 0
        self.canLoadMoreRankTagProduct = true
        self.recommendProducts = []
        self.userRankTagisIitialLoading = true
        getUserRecommendTag(tag: selectedCategory.toPartItemRawValue() ?? "EAR", page: userProductPage)
    }
    
    
}
