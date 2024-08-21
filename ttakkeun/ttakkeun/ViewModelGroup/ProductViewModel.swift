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
    @Published var aiProductData: [ProductDetailData]?
    @Published var userProductData: [ProductDetailData]?
    
    private var provider: MoyaProvider<ProductRecommendAPITarget>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<ProductRecommendAPITarget> = APIManager.shared.createProvider(for: ProductRecommendAPITarget.self)) {
        self.provider = provider
    }
    
    // MARK: - AI Product API Function
    
    /// AIProduct 조회 함수
    public func getAIProduct(petId: Int) async {
        provider.request(.getAIRecommend(petId: petId)) { [weak self] result in
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
            let decodeData = try JSONDecoder().decode(ResponseData<[ProductDetailData]>.self, from: response.data)
            if decodeData.isSuccess {
                DispatchQueue.main.async {
                    self.aiProductData = decodeData.result
                }
            } else {
                print("AI 상품 조회 네트워크 오류: \(decodeData.message)")
            }
        } catch {
            print("AI 상품 조회 디코더 에러: \(error)")
        }
    }
    
    // MARK: - User Product API Function
    
    /// 유저 추천 상품 조회 API
    /// - Parameter page: 물품 페이지 번호
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
            let decodedData = try JSONDecoder().decode(ResponseData<[ProductDetailData]>.self, from: response.data)
            if decodedData.isSuccess {
                DispatchQueue.main.async {
                    self.userProductData = decodedData.result
                    print("유저 추천 제품 데이터 디코더 완료")
                }
            } else {
                print("유저 추천 제품 네트워크 에러: \(decodedData.message)")
            }
        } catch {
            print("유저 추천 상품 디코더 에러: \(error)")
        }
    }
}
