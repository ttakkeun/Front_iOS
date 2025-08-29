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
    // MARK: - StateProperty
    var isLoadingRankTagProduct: Bool = false
    var isLoadingAIProduct: Bool = false
    var isLoadingUserProduct: Bool = false
    var isLoadingSheetView: Bool = false
    var isShowSheetView: Bool = false
    var canLoadMoarUserProduct: Bool = true
    var userAllisIitialLoading: Bool = true
    var canLoadMoreRankTagProduct: Bool = true
    var userRankTagisIitialLoading: Bool = true
    
    var userProductPage: Int = 0
    
    // MARK: - Property
    var aiProducts: [ProductResponse] = []
    var recommendProducts: [ProductResponse] = []
    var selectedData: ProductResponse? = nil
    var selectedCategory: ExtendPartItem = .all
    var selectedSource: RecommendProductType = .none
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
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
    
    func startNewUserProductAll() {
        self.userProductPage = 0
        self.canLoadMoarUserProduct = true
        self.recommendProducts = []
        self.userAllisIitialLoading = true
        getUserRecommendAll(page: userProductPage)
    }
  
    func startNewRankTagProducts() {
        self.userProductPage = 0
        self.canLoadMoreRankTagProduct = true
        self.recommendProducts = []
        self.userRankTagisIitialLoading = true
        getUserRecommendTag(tag: selectedCategory.toPartItemRawValue() ?? "EAR", page: userProductPage)
    }

    func makeLikePatchRequest(data: ProductResponse) -> ProductLikeRequest {
        return .init(
            title: data.title,
            image: data.image,
            price: data.price,
            brand: data.brand ?? "",
            link: data.purchaseLink,
            category1: data.category1 ?? "",
            category2: data.category2 ?? "",
            category3: data.category3 ?? "",
            category4: data.category4 ?? ""
        )
    }
    
    // MARK: - AI Products
    /// AI 추천 제품 받아오기
    func getAIProucts() {
        isLoadingAIProduct = true
        
        container.useCaseProvider.productUseCase.executeGetAIRecommendData(petId: petId)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoadingAIProduct = false }
                
                switch completion {
                case .finished:
                    print("getAIRecommendProducts Server Completed")
                case .failure(let failure):
                    print("getAIRecommendProducts Server Failure \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self else { return }
                self.aiProducts = responseData
            })
            .store(in: &cancellables)
    }
    
    // MARK: - User Products
    func getUserRecommendAll(page: Int) {
        guard !isLoadingUserProduct && canLoadMoarUserProduct else { return }
        isLoadingUserProduct = true
        container.useCaseProvider.productUseCase.executeGetRankProductData(pageNum: page)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoadingUserProduct = false }
                switch completion {
                case .finished:
                    print("getUser Recommend Product Server Completed")
                case .failure(let failure):
                    print("getUser Recommend Product Server Failure \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                let data = responseData
                if !data.isEmpty {
                    self.recommendProducts.append(contentsOf: data)
                    self.canLoadMoarUserProduct = true
                } else {
                    self.canLoadMoarUserProduct = false
                }
                self.userAllisIitialLoading = false
            })
            .store(in: &cancellables)
    }
    
    func getUserRecommendTag(tag: PartItem.RawValue, page: Int) {
        guard !isLoadingRankTagProduct && canLoadMoreRankTagProduct else { return }
        isLoadingRankTagProduct = true
        
        container.useCaseProvider.productUseCase.executeGetRankProductTagData(tag: tag, page: page)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoadingRankTagProduct = false }
                switch completion {
                case .finished:
                    print("getUserRecommendProductsTag Server Completed")
                case .failure(let failure):
                    print("getUserRecommendProductsTag Server Failure \(failure)")
                    canLoadMoreRankTagProduct = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                let data = responseData
                if !data.isEmpty {
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
    
    // MARK: - Like
    
    /// 좋아요 누른 상품
    /// - Parameters:
    ///   - productId: 상품 ID
    ///   - productData: 상품 정보
    func likeProduct(productId: Int, productData: ProductLikeRequest) {
        container.useCaseProvider.productUseCase.executePutLikeProductData(productId: productId, likeData: productData)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("ProductLike Server Completed")
                case .failure(let failure):
                    print("ProductLike Server Failure \(failure)")
                }
            }, receiveValue: { responseData in
                
                #if DEBUG
                print("ProductLike: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
}

