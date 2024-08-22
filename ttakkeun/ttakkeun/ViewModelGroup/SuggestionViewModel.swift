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
    
    private let provider: MoyaProvider<SuggestionAPITarget>
    
    // MARK: - Init
    init(provider: MoyaProvider<SuggestionAPITarget> = APIManager.shared.createProvider(for: SuggestionAPITarget.self)) {
        self.provider = provider
    }
  
    // MARK: - API Functions
    
    public func loadInitialData() async {
         // 초기 petId와 page 값을 0으로 설정
         await getAiProducts(petId: 0)
         await getRankedProducts(page: 0)
     }
    
    public func performSearch(for keyword: String) async {
           await getSearchedProductsByDB(for: keyword, page: 0)
           await getSearchedProductsByNaver(for: keyword)
       }
    
    public func getAiProducts(petId: Int) async {
        let petId = 0
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
        let page = 0
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
        let page = 0
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
        let page = 0
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
        if !responseIsJson(response: response) { return }
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }
            let decodedResponse = try JSONDecoder().decode(ResponseData<[RecommenProductResponseData]>.self, from: response.data)
            DispatchQueue.main.async {
                if let products = decodedResponse.result, !products.isEmpty {
                    self.aiProducts = products
                    print("AI 추천 상품 API 호출 성공")
                } else {
                    print("AI 추천 상품 API 호출 실패: No products found in result")
                }
            }
        } catch {
            print("AI 추천 상품 디코더 에러: \(error)")
        }
    }


    private func handleResponseForRankedProducts(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                                  print("Received JSON: \(jsonString)")
                              }
            let decodedResponse = try JSONDecoder().decode(ResponseData<[RecommenProductResponseData]>.self, from: response.data)
            DispatchQueue.main.async {
                if let products = decodedResponse.result {
                    self.products = products
                    print("랭킹별 상품 API 호출 성공")
                } else {
                    print("랭킹별 상품 API 호출 실패: No products found")
                }
            }
        } catch {
            print("랭킹별 상품 디코더 에러: \(error)")
        }
    }

    private func handleResponseForCategoryProducts(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                                  print("Received JSON: \(jsonString)")
                              }
            let decodedResponse = try JSONDecoder().decode(ResponseData<[RecommenProductResponseData]>.self, from: response.data)
            DispatchQueue.main.async {
                if let products = decodedResponse.result {
                    self.categoryProducts = products
                    print("카테고리 상품 API 호출 성공")
                } else {
                    print("카테고리 상품 API 호출 실패: No products found")
                }
            }
        } catch {
            print("카테고리 상품 디코더 에러: \(error)")
        }
    }

    private func handleResponseForToggleLike(response: Response, productId: Int) {
        if !responseIsJson(response: response) { return }
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                                  print("Received JSON: \(jsonString)")
                              }
            let decodedResponse = try JSONDecoder().decode(ResponseData<LikeResponseDTO>.self, from: response.data)
            DispatchQueue.main.async {
                if let likeResponse = decodedResponse.result {
                    if let index = self.products.firstIndex(where: { $0.product_id == productId }) {
                        self.products[index].isLike = likeResponse.like
                        self.products[index].total_likes = likeResponse.totalLikes
                    }
                    print("하트 변경 API 호출 성공")
                } else {
                    print("하트 변경 API 호출 실패: No like response found")
                }
            }
        } catch {
            print("하트 변경 디코더 에러: \(error)")
        }
    }

    private func handleResponseForSearchDB(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                                  print("Received JSON: \(jsonString)")
                              }
            let decodedResponse = try JSONDecoder().decode(ResponseData<[RecommenProductResponseData]>.self, from: response.data)
            DispatchQueue.main.async {
                if let products = decodedResponse.result {
                    if self.searchResults != nil {
                        self.searchResults!.dbProducts = products
                    } else {
                        self.searchResults = (dbProducts: products, naverProducts: [])
                    }
                    print("DB 검색 결과 API 호출 성공")
                } else {
                    print("DB 검색 결과 API 호출 실패: No products found")
                }
            }
        } catch {
            print("DB 검색 결과 디코더 에러: \(error)")
        }
    }

    private func handleResponseForSearchNaver(response: Response) {
        if !responseIsJson(response: response) { return }
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                                  print("Received JSON: \(jsonString)")
                              }
            let decodedResponse = try JSONDecoder().decode(ResponseData<[RecommenProductResponseData]>.self, from: response.data)
            DispatchQueue.main.async {
                if let products = decodedResponse.result {
                    if self.searchResults != nil {
                        self.searchResults!.naverProducts = products
                    } else {
                        self.searchResults = (dbProducts: [], naverProducts: products)
                    }
                    print("네이버 검색 결과 API 호출 성공")
                } else {
                    print("네이버 검색 결과 API 호출 실패: No products found")
                }
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
