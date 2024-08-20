//
//  SuggestionInitialView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import SwiftUI

struct SuggestionInitialView: View {
    
    @State var existAi: Bool = false
    
    @ObservedObject var viewModel: SuggestionViewModel
    
    //MARK: - Init
    init(viewModel: SuggestionViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Contents
    var body: some View {
      
        VStack(spacing: 0) {
            TopStatusBar()
                .padding(.vertical, 10)
            ScrollView(.vertical, showsIndicators: false){
                CustomTextField(
                    text: Binding(get: { "" }, set: { _ in "" }),
                    placeholder: "검색어를 입력하세요",
                    fontSize: 16,
                    cornerRadius: 20,
                    padding: 23,
                    showGlass: true,
                    maxWidth: 353,
                    maxHeight: 40
                )
                .padding(.top, 15)
                .onAppear {
                    UIApplication.shared.hideKeyboard()
                }
                Contents
            }
        }
    }
    
    
    private var Contents: some View {
      
        VStack(spacing: 24) {
         
            categorySegmentedControl
                    .padding(.top, 17)
            
                aiProductSet
                .padding(.top, -10)
                
                productSet
                Spacer()
            }

        
    }
    
  
    
    private var categorySegmentedControl: some View {
           ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 8) {
                   ForEach(RecommendProductSegment.allCases, id: \.self) { category in
                       Button(action: {
                           viewModel.selectedCategory = category
//                           Task {
//                               await viewModel.getProducts(for: category)
//                           }
                       }) {
                           Text(category.toKorean())
                               .frame(width: 40, height: 20, alignment: .center)
                               .font(.Body2_medium)
                               .foregroundStyle(Color.gray900)
                               .foregroundColor(viewModel.selectedCategory == category ? .white : .black)
                               .padding(.horizontal, 18.5)
                               .padding(.vertical, 8)
                               .background(
                                   RoundedRectangle(cornerRadius: 999)
                                       .stroke(Color.gray600, lineWidth: 2.5)
                               )
                               .background(viewModel.selectedCategory == category ? Color.primarycolor_200 : Color.clear)
                               .clipShape(RoundedRectangle(cornerRadius: 999))
                       }
                   }
               }
               .padding(.horizontal, 19)
           }
       }
    
    
    private var aiProductSet: some View {
        VStack(spacing: -2){
            aiRecommendProductText
                .padding(.leading, 21)
            aiRecommendProduct

        }
        .padding(.top, 17)
    }
    
    
    private var aiRecommendProductText: some View {
        HStack(spacing: 2){
            Icon.recommendDog.image
                .fixedSize()
            Text("따끈따끈 AI 최근 추천")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
    }
    
    private var aiRecommendProduct: some View {
        Group {
            if viewModel.aiProducts.isEmpty {
                HomeAINotRecommend()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.aiProducts) { product in
                            RecommendProductbyAI(data: product)
                        }
                    }
                    .padding(.horizontal, 21)
                }
            }
        }
    }
    
    
    private var productSet: some View {
        VStack(alignment: .leading, spacing: 16){
            recommendText
            recommendProduct
        }
    }
    
    
    private var recommendText: some View {
        HStack{
            Text("랭킹별 추천상품")
                .padding(.leading, 21)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            Spacer()
        }
    }
        
    
    private var recommendProduct: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.filteredProducts) { product in
                RecommendProduct(
                    data: product,
                    rank: viewModel.products.firstIndex(of: product) ?? 0
                )
            }
        }
        .padding(.horizontal, 21)
    }
}



#Preview {
    SuggestionInitialView(viewModel: SuggestionViewModel())
}
