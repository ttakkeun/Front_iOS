//
//  RecommendViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import Foundation
import Combine
import CombineMoya

@Observable
class HomeRecommendViewModel {
    // MARK: - StateProperty
    var aiRecommendIsLoading: Bool = true
    var userRecommendIsLoading: Bool = true
    
    // MARK: - Property
    var aiProduct: [ProductResponse] = []
    var userProduct: [ProductResponse] = []
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    
    // MARK: - Dependency
    private var aiCancellables = Set<AnyCancellable>()
    private var userCancellables = Set<AnyCancellable>()
    let container: DIContainer
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    deinit {
        aiCancellables.forEach { $0.cancel() }
        userCancellables.forEach { $0.cancel() }
    }
    
    // MARK: - GetAIProductAPI
    /// AI 추천 상품 조회
    public func getAIProduct() {
        self.aiRecommendIsLoading = true
        
        container.useCaseProvider.productUseCase.executeGetAIRecommendData(petId: petId)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.aiRecommendIsLoading = false }
                
                if case .failure(let error) = completion {
                    print("Home Get AIProduct Failed: \(error)")
                    aiProduct = []
                }
            }, receiveValue: { [weak self] aiProductData in
                guard let self = self else { return }
                self.aiProduct = aiProductData
                
                #if DEBUG
                print("aiProduct: \(String(describing: self.aiProduct))")
                #endif
            })
            .store(in: &aiCancellables)
    }
    
    // MARK: - GetUserProductAPI
    /// 유저 추천 상품 조회
    public func getUserProduct() {
        self.userRecommendIsLoading = true
        
        container.useCaseProvider.productUseCase.executeGetRankProductData(pageNum: .zero)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.userRecommendIsLoading = false
                }
                
                if case .failure(let error) = completion {
                    print("Home Get UserProduct Failed: \(error)")
                }
            }, receiveValue: { [weak self] userProductData in
                guard let self = self else { return }
                self.userProduct = userProductData
            })
            .store(in: &userCancellables)
    }
}
