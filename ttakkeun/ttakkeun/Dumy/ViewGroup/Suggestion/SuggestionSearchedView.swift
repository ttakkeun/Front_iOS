//
//  SuggestionSearchedView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import SwiftUI

struct SuggestionSearchedView: View {
    
    @State private var selectedProduct: RecommenProductResponseData? = nil
    
    var dbProducts: [RecommenProductResponseData] = [
      ]
      
      // 네이버에서 검색된 외부 추천 상품 배열
      var naverProducts: [RecommenProductResponseData] = [
      ]
    
    var body: some View {
         ScrollView(.vertical, showsIndicators: true){
             VStack(spacing: 27){
                 dbProductSet
                 naverProductSet
             }
             .sheet(item: $selectedProduct) { product in
                 ProductSheetView(data: product)
                     .presentationDetents([.fraction(0.62)])
                     .presentationDragIndicator(.hidden)
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
                     .onTapGesture {
                         selectedProduct = product
                     }
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
                     .onTapGesture {
                         selectedProduct = product
                     }
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
