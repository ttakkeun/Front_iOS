//
//  RecommendationViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya

@Observable
class RecommendationProductViewModel: TapGestureProduct, ProductUpdate {
    
    var selectedCategory: ExtendPartItem = .all
    var aiProducts: [ProductResponse] = []
    var recommendProducts: [ProductResponse] = []
    
    var isLoadingAIProduct: Bool = false
    
    var isLoadingUserProduct: Bool = false
    var canLoadMoarUserProduct: Bool = true
    var userAllisIitialLoading: Bool = true
    
    // MARK: - RankTag
    var isLoadingRankTagProduct: Bool = false
    var canLoadMoreRankTagProduct: Bool = true
    var userRankTagisIitialLoading: Bool = true
    
    var userProductPage: Int = 0
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func goToSearchView() {
        container.navigationRouter.push(to: .recommend(.productSearch))
    }
    
    // MARK: - ProductSheet
    
    var selectedData: ProductResponse? = nil
    var isLoadingSheetView: Bool = false
    var isShowSheetView: Bool = false
    var selectedSource: RecommendProductType = .none
    
    func handleTap(data: ProductResponse, source: RecommendProductType) {
        self.selectedData = data
        self.selectedSource = source
        self.isLoadingSheetView = true
    }
    
    func updateProduct(_ updateProduct: ProductResponse) {
        switch self.selectedSource {
        case .aiProduct:
            if let index = aiProducts.firstIndex(where: { $0.id == updateProduct.id }) {
                aiProducts[index] = updateProduct
            }
        case .userProduct:
            if let index = recommendProducts.firstIndex(where: { $0.id == updateProduct.id }) {
                recommendProducts[index] = updateProduct
            }
        default:
            break
        }
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
    
    func likeProduct(productId: Int, productData: LikePatchRequest) {
        container.useCaseProvider.productRecommendUseCase.executeLikeProduct(productId: productId, likeData: productData)
            .tryMap { responseData -> ResponseData<LikeProductResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ ProductLike Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ ProductLike Server Completed")
                case .failure(let failure):
                    print("❌ ProductLike Server Failure \(failure)")
                }
            },
                  receiveValue: { responseData in
                if let result = responseData.result {
                    print("ProductLike: \(result)")
                }
            })
            .store(in: &cancellables)
    }
    
    func makeLikePatchRequest(data: ProductResponse) -> LikePatchRequest {
        return LikePatchRequest(title: data.title,
                                image: data.image,
                                price: data.price,
                                brand: data.brand ?? "",
                                link: data.purchaseLink,
                                category1: data.category1 ?? "",
                                category2: data.category2 ?? "",
                                category3: data.category3 ?? "",
                                category4: data.category4 ?? "")
    }
}
