//
//  SuggestionSearchedView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import SwiftUI

struct SuggestionSearchedView: View {
    var dbProducts: [RecommenProductResponseData] = [
          // 예시 데이터 추가 (실제 데이터로 대체)
          RecommenProductResponseData(product_id: 1, title: "아껴주다 저자극 천연 고양이 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg", price: 12000, brand: "지강", link: "https://example.com", category1: "지강", category2: "지강", category3: "지강", category4: "지강", total_likes: 123, isLike: true),
          RecommenProductResponseData(product_id: 2, title: "강아지용 무자극 천연 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422009.jpg", price: 15000, brand: "지강", link: "https://example.com", category1: "지강", category2: "지강", category3: "지강", category4: "지강", total_likes: 90, isLike: false),
          RecommenProductResponseData(product_id: 3, title: "강아지용 무자극 천연 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422009.jpg", price: 15000, brand: "지강", link: "https://example.com", category1: "지강", category2: "지강", category3: "지강", category4: "지강", total_likes: 90, isLike: false),
          RecommenProductResponseData(product_id: 4, title: "강아지용 무자극 천연 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422009.jpg", price: 15000, brand: "지강", link: "https://example.com", category1: "지강", category2: "지강", category3: "지강", category4: "지강", total_likes: 90, isLike: false)
      ]
      
      // 네이버에서 검색된 외부 추천 상품 배열
      var naverProducts: [RecommenProductResponseData] = [
          // 예시 데이터 추가 (실제 데이터로 대체)
          RecommenProductResponseData(product_id: 3, title: "바박 파이오멕 약용샴푸 200ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422010.jpg", price: 22200, brand: "네이버 브랜드", link: "https://example.com", category1: "네이버", category2: "네이버", category3: "네이버", category4: "네이버", total_likes: 2170, isLike: true),
          RecommenProductResponseData(product_id: 4, title: "퓨엠프레젠즈 퓨어 밸런스 천연 강아지 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422011.jpg", price: 18000, brand: "네이버 브랜드", link: "https://example.com", category1: "네이버", category2: "네이버", category3: "네이버", category4: "네이버", total_likes: 990, isLike: true)
      ]
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true){
            VStack(spacing: 27){
                dbProductSet
                naverProductSet
            }
        }
    }
    
    /// db추천상품 셋
    private var dbProductSet: some View {
        VStack(spacing: 0) {
            dbRecommendProductText
            dbRecommendProduct
        }
    }
    
    /// 네이버추천상품 셋
    private var naverProductSet: some View {
        VStack{
            naverRecommendText
            naverRecommendProduct
        }
    }
    
    
    /// 따끈따끈 추천 상품
    private var dbRecommendProductText: some View {
        HStack(spacing: 2){
            Icon.recommendDog.image
                .fixedSize()
            Text("따끈따끈 추천 상품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
        .padding(.leading, 21)
    }
    
    
    /// db추천상품
    private var dbRecommendProduct: some View {
        ScrollView(.vertical,showsIndicators: true) {
               VStack(spacing: 16) {
                   ForEach(dbProducts, id: \.product_id) { product in
                       RecommendProduct(
                           data: product,
                           rank: dbProducts.firstIndex(of: product) ?? 0
                       )
                   }
               }
           }
        .frame(height: 250)
           .padding(.top, 16)
           .padding(.horizontal, 11)
           .background(Color.productBackground)
           .clipShape(RoundedRectangle(cornerRadius: 10))
       }
    
    /// 외부검색상품텍스트
    private var naverRecommendText: some View {
        HStack{
            Text("외부 검색 상품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
        .padding(.leading, 17)
    }
                    
                    
    private var naverRecommendProduct: some View {
           ScrollView {
               VStack(spacing: 16) {
                   ForEach(naverProducts, id: \.product_id) { product in
                       RecommendProduct(
                           data: product,
                           rank: naverProducts.firstIndex(of: product) ?? 0
                       )
                   }
               }
               .padding(.bottom, 80)
           }
       }
}

//MARK: - Preview
struct SuggestionSearchedView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro", "iPhone 15 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            SuggestionSearchedView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}

