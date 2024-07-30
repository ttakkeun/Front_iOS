//
//  HomeProductViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/30/24.
//

import Foundation
import Moya

@MainActor
class ProductViewModel: ObservableObject {
    @Published var aiProductData: AIAndSearchProductData?
    
    private var provider: MoyaProvider<ProductRecommendAPITarget>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<ProductRecommendAPITarget> = APIManager.shared.testProvider(for: ProductRecommendAPITarget.self)) {
        self.provider = provider
    }
    
    // MARK: - API Function
    
    /// AIProduct 조회 함수
    public func getAIProduct() async {
        provider.request(.getAIRecommend) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleAIProductResponse(response: response)
            case .failure(let error):
                print("AI 상품 네트워크 에러: \(error)")
            }
        }
    }
    
    /// AI 상품 추천 Response 핸들러
    /// - Parameter response: response 값
    private func handleAIProductResponse(response: Response) {
        do {
            let decodeData = try JSONDecoder().decode(AIAndSearchProductData.self, from: response.data)
            DispatchQueue.main.async {
                self.aiProductData = decodeData
            }
        } catch {
            print("AI 상품 조회 디코더 에러: \(error)")
        }
    }
}
