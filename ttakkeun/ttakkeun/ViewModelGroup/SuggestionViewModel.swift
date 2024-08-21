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
        ),
        RecommenProductResponseData(
            product_id: 4,
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
        ),
        RecommenProductResponseData(
            product_id: 5,
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
    @Published var categoryProducts: [RecommenProductResponseData] = []
    @Published var selectedCategory: RecommendProductSegment = .all
    @Published var searchResults: (dbProducts: [RecommenProductResponseData], naverProducts: [RecommenProductResponseData])? = nil
  
    //MARK: - API Function

    /// 초기 화면 로딩 시 AI와 All 데이터를 가져오기 위한 함수
      public func loadInitialData() async {
          await getAiProducts()
          await getAllProducts()
      }
    
    /// 검색하면 키워드 를 path variable로 넣고 get요청받아야함
    /// - Parameter keyword: 검색단어
    public func performSearch(for keyword: String) async {
         await getSearchedProductsByDB(for: keyword)
        await getSearchedProductsByNaver(for: keyword)
     }
      
      // TODO: - AI추천 상품을 가져오는 API 호출 함수
      public func getAiProducts() async {
          // API 호출 로직을 여기에 작성합니다.
          // 예시: provider.request(.getAiProducts) { ... }
          // 성공적으로 데이터를 받으면 self.aiProducts에 할당합니다.
      }
      
      // TODO: - 전체 상품을 가져오는 API 호출 함수
      public func getAllProducts() async {
          // API 호출 로직을 여기에 작성합니다.
          // 예시: provider.request(.getAllProducts) { ... }
          // 성공적으로 데이터를 받으면 self.products에 할당합니다.
      }
      
      // TODO: - 특정 카테고리의 상품을 가져오는 API 호출 함수
      public func getCategoryProducts(for category: String) async {
          // API 호출 로직을 여기에 작성합니다.
          // category를 path variable로 사용하여 해당 카테고리 상품을 요청합니다.
          // 성공적으로 데이터를 받으면 self.categoryProducts에 할당합니다.
      }
      
      // TODO: - 하트 수 변경 API 호출 함수
      public func patchHeartNum(for productId: Int) async {
          // 하트 수 변경을 위한 API 호출 로직을 여기에 작성합니다.
          // productId를 사용하여 특정 상품의 하트 수를 변경합니다.
      }
      
      // TODO: - 따끈DB에 있는 검색결과 상품 가져오는 API 호출 함수
      public func getSearchedProductsByDB(for keyWord: String) async {
          // 따끈DB에서 검색결과를 가져오는 API 호출 로직을 여기에 작성합니다.
          // searchText를 사용하여 검색된 상품 리스트를 가져옵니다.
      }
      
      // TODO: - 네이버API 사용해 검색결과 상품 가져오는 API 호출 함수
    public func getSearchedProductsByNaver(for keyWord: String) async {
          // 네이버 API를 사용하여 검색결과를 가져오는 API 호출 로직을 여기에 작성합니다.
          // searchText를 사용하여 검색된 상품 리스트를 가져옵니다.
      }
  }
    

