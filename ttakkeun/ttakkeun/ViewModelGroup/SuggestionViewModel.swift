//
//  SuggestionViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//
import SwiftUI
import Moya
import Foundation

/// 추천 상품 리스트를 관리하는 뷰모델
@MainActor
class SuggestionViewModel: ObservableObject {

    @Published var products: [RecommenProductResponseData] = []
    @Published var aiProducts: [RecommenProductResponseData] = []
    @Published var categoryProducts: [RecommenProductResponseData] = []
    @Published var searchResults: (dbProducts: [RecommenProductResponseData], naverProducts: [RecommenProductResponseData])? = nil
    @Published var selectedCategory: RecommendProductSegment = .all
    
    private let provider: MoyaProvider<ProductAPITarget>
    
    // MARK: - Init
    init(provider: MoyaProvider<ProductAPITarget> = APIManager.shared.createProvider(for: ProductAPITarget.self)) {
        self.provider = provider
    }
  
    // MARK: - API Functions
    
    public func loadInitialData() async {
        await getAiProducts(petId: 1)  // Pet ID는 예시로 1을 사용, 실제로는 동적으로 할당
        await getRankedProducts(page: 1)
    }
    
    public func getAiProducts(petId: Int) async {
        provider.request(.getAiProducts(petId: petId)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponseForAiProducts(response: response)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    public func getRankedProducts(page: Int) async {
        provider.request(.getRankedProducts(page: page)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponseForRankedProducts(response: response)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    public func getCategoryProducts(for category: String, page: Int) async {
        provider.request(.getTagRankingProducts(tag: category, page: page)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponseForCategoryProducts(response: response)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    public func toggleLikeProduct(for productId: Int, requestBody: ProductRequestDTO) async {
        provider.request(.toggleLikeProduct(productId: productId, requestBody: requestBody)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponseForToggleLike(response: response, productId: productId)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    public func getSearchedProductsByDB(for keyword: String, page: Int) async {
        provider.request(.getSearchProductsFromDB(keyword: keyword, page: page)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponseForSearchDB(response: response)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    public func getSearchedProductsByNaver(for keyword: String) async {
        provider.request(.getSearchProductsFromNaver(keyword: keyword)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleResponseForSearchNaver(response: response)
            case .failure(let error):
                print("네트워크 오류: \(error)")
            }
        }
    }
    
    // MARK: - Response Handlers
    
    private func handleResponseForAiProducts(response: Response) {
        if !responseIsJson(response: response) { return } // JSON이 아닌 경우 반환
        do {
            let decodedData = try JSONDecoder().decode([RecommenProductResponseData].self, from: response.data)
            DispatchQueue.main.async {
                self.aiProducts = decodedData
                print("AI 추천 상품 API 호출 성공")
            }
        } catch {
            print("AI 추천 상품 디코더 에러: \(error)")
        }
    }

    
    private func handleResponseForRankedProducts(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            let decodedData = try JSONDecoder().decode([RecommenProductResponseData].self, from: response.data)
            DispatchQueue.main.async {
                self.products = decodedData
                print("랭킹별 상품 API 호출 성공")
            }
        } catch {
            print("랭킹별 상품 디코더 에러: \(error)")
        }
    }
    
    private func handleResponseForCategoryProducts(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            let decodedData = try JSONDecoder().decode([RecommenProductResponseData].self, from: response.data)
            DispatchQueue.main.async {
                self.categoryProducts = decodedData
                print("카테고리 상품 API 호출 성공")
            }
        } catch {
            print("카테고리 상품 디코더 에러: \(error)")
        }
    }
    
    private func handleResponseForToggleLike(response: Response, productId: Int) {
        if !responseIsJson(response: response) { return }
        do {
            let decodedData = try JSONDecoder().decode(LikeResponseDTO.self, from: response.data)
            DispatchQueue.main.async {
                if let index = self.products.firstIndex(where: { $0.product_id == productId }) {
                    self.products[index].isLike = decodedData.like
                    self.products[index].total_likes = decodedData.totalLikes
                }
                print("하트 변경 API 호출 성공")
            }
        } catch {
            print("하트 변경 디코더 에러: \(error)")
        }
    }
    
    private func handleResponseForSearchDB(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            let decodedData = try JSONDecoder().decode([RecommenProductResponseData].self, from: response.data)
            DispatchQueue.main.async {
                if self.searchResults != nil {
                    self.searchResults!.dbProducts = decodedData
                } else {
                    self.searchResults = (dbProducts: decodedData, naverProducts: [])
                }
                print("DB 검색 결과 API 호출 성공")
            }
        } catch {
            print("DB 검색 결과 디코더 에러: \(error)")
        }
    }
    
    private func handleResponseForSearchNaver(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            let decodedData = try JSONDecoder().decode([RecommenProductResponseData].self, from: response.data)
            DispatchQueue.main.async {
                if self.searchResults != nil {
                    self.searchResults!.naverProducts = decodedData
                } else {
                    self.searchResults = (dbProducts: [], naverProducts: decodedData)
                }
                print("네이버 검색 결과 API 호출 성공")
            }
        } catch {
            print("네이버 검색 결과 디코더 에러: \(error)")
        }
    }

    // Helper function to check if the response is JSON
    private func responseIsJson(response: Response) -> Bool {
        if let mimeType = response.response?.mimeType, mimeType != "application/json" {
            print("Expected JSON but received \(mimeType): \(String(data: response.data, encoding: .utf8) ?? "")")
            return false
        }
        return true
    }
}
