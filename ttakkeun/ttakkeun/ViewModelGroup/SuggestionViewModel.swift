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
    
    @Published var products: [RecommenProductResponseData] = [
        RecommenProductResponseData(
            product_id: 1,
            title: "아껴주다 저자극 천연 고양이 샴푸 500ml",
            image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg",
            price: 13000,
            brand: "지강",
            link: "https://smartstore.naver.com/main/products/7619827035",
            category1: "지강",
            category2: "지강",
            category3: "지강",
            category4: "지강",
            total_likes: 123,
            isLike: true
        ),
        RecommenProductResponseData(
            product_id: 2,
            title: "강아지용 무자극 천연 샴푸 500ml",
            image: "https://shopping-phinf.pstatic.net/main_3596342/35963422009.jpg",
            price: 15000,
            brand: "지강",
            link: "https://smartstore.naver.com/main/products/7619827036",
            category1: "지강",
            category2: "지강",
            category3: "지강",
            category4: "지강",
            total_likes: 90,
            isLike: false
        )
    ]
    
    @Published var aiProducts: [RecommenProductResponseData] = [
        RecommenProductResponseData(
            product_id: 3,
            title: "AI 추천 저자극 천연 고양이 샴푸 500ml",
            image: "https://shopping-phinf.pstatic.net/main_3596342/35963422010.jpg",
            price: 14000,
            brand: "지강",
            link: "https://smartstore.naver.com/main/products/7619827037",
            category1: "지강",
            category2: "지강",
            category3: "지강",
            category4: "지강",
            total_likes: 110,
            isLike: true
        )
    ]
    @Published var selectedCategory: RecommendProductSegment = .all
  
    //MARK: - API Function
    
    /// 전체와 특정 카테고리에 따라 분류된 상품 목록을 반환하는 함수
    public var filteredProducts: [RecommenProductResponseData] {
        switch selectedCategory {
        case .all:
            return products
        default:
            return products.filter { $0.category1 == selectedCategory.rawValue }
        }
    }
    
    
    /// API 호출을 통해 카테고리별 상품 리스트를 가져오는 함수
    public func getProducts() async {
        switch selectedCategory {
        case .all:
            await getAllProducts()
        default:
            await getCategoryProducts()
        }
    }
    
    
    //TODO: - AI추천 상품을 가져오는 API 호출 함수
    private func getAiProducts() async {
        
    }
    
    //TODO: - 전체 상품을 가져오는 API 호출 함수
    private func getAllProducts() async {
        
    }
    
    //TODO: - 특정 카테고리의 상품을 가져오는 API 호출 함수
    private func getCategoryProducts() async {
        
    }
    
    //TODO: - 하트 수 변경 API 호출 함수
    private func patchHeartNum() async {
        
    }
    
    //TODO: - 따끈DB에 있는 검색결과 상품 가져오는 API 호출 함수
    private func getSearchedProductsByDB() async {
        
    }
    
    //TODO: - 네이버API사용해 검색결과 상품 가져오는 API 호출 함수
    private func getSearchedProductsByNaver() async {
        
    }
    
    
    
}
