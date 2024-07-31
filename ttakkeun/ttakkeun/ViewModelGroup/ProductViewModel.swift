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
    @Published var userProductData: AIAndSearchProductData?
    
    private var provider: MoyaProvider<ProductRecommendAPITarget>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<ProductRecommendAPITarget> = APIManager.shared.testProvider(for: ProductRecommendAPITarget.self)) {
        self.provider = provider
    }
    
    // MARK: - AI Product API Function
    
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
    
    // MARK: - User Product API Function
    
    /// 유저 추천 상품 조회 API
    /// - Parameter page: <#page description#>
    public func getUserProduct(page: Int) async {
        provider.request(.getRankProduct(pageNum: page)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleUserProductResponse(response: response)
            case .failure(let error):
                print("유저 추천 상품 조회 네트워크 에러: \(error)")
            }
        }
    }
    
    /// 유저 추천 프로덕트 상품 조회
    /// - Parameter response: response 값
    private func handleUserProductResponse(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(AIAndSearchProductData.self, from: response.data)
            DispatchQueue.main.async {
                self.userProductData = decodedData
            }
        } catch {
            print("유저 추천 상품 디코더 에러: \(error)")
        }
    }
}
