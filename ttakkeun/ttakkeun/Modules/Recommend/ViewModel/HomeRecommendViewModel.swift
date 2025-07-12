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
    var aiProduct: [ProductResponse] = []
    var userProduct: [ProductResponse] = []
    var aiRecommendIsLoading: Bool = true
    var userRecommendIsLoading: Bool = true
    
    private var aiCancellables = Set<AnyCancellable>()
    private var userCancellables = Set<AnyCancellable>()
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    deinit {
        aiCancellables.forEach { $0.cancel() }
        userCancellables.forEach { $0.cancel() }
    }
}

// MARK: - GetProduct API

extension HomeRecommendViewModel {
    public func getAIProduct() {
        DispatchQueue.main.async {
            self.aiRecommendIsLoading = true
        }
        
        container.useCaseProvider.productRecommendUseCase.executeGetAIRecommend(petId: UserState.shared.getPetId())
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.aiRecommendIsLoading = false
                }
                
                if case .failure(let error) = completion {
                    print("Home Get AIProduct Failed: \(error)")
                    aiProduct = []
                }
            }, receiveValue: { [weak self] aiProductData in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let result = aiProductData.result {
                        self.aiProduct = result
                        print("aiProduct: \(String(describing: self.aiProduct))")
                    }
                }
            })
            .store(in: &aiCancellables)
    }
    
    public func getUserProduct() {
        DispatchQueue.main.async {
            self.userRecommendIsLoading = true
        }
        
        container.useCaseProvider.productRecommendUseCase.executeGetRankProduct(pageNum: 0)
            .tryMap { responseData -> ResponseData<[ProductResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                return responseData
            }
            .receive(on: DispatchQueue.main)
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
                DispatchQueue.main.async {
                    if let result = userProductData.result {
                        self.userProduct = result
                    }
                }
            })
            .store(in: &userCancellables)
    }
}
