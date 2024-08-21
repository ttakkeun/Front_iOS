//
//  SuggestionInitialView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/21/24.
//

import SwiftUI

struct SuggestionInitialView: View {
    
    @ObservedObject var viewModel: SuggestionViewModel
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @State private var selectedProduct: RecommenProductResponseData? = nil
    
    //MARK: - Init
    init(viewModel: SuggestionViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Contents
     var body: some View {
         VStack(spacing: 0) {
             if !isSearching {
                 TopStatusBar()
                     .padding(.top, 10)
                     .padding(.bottom, 20)
                     .transition(.move(edge: .top).combined(with: .opacity))
             }
             ScrollView(.vertical, showsIndicators: false){
                 VStack(spacing: 16) {
                     searchBar
                         .transition(.move(edge: .top).combined(with: .opacity))
                     
                     if !isSearching {
                         Contents
                     } else if let searchResults = viewModel.searchResults {
                         SuggestionSearchedView(dbProducts: searchResults.dbProducts, naverProducts: searchResults.naverProducts)
                     }
                 }
                 .frame(maxWidth: .infinity).ignoresSafeArea(.all)
             }
             .animation(.easeInOut(duration: 0.3), value: isSearching)
         }
         .sheet(item: $selectedProduct) { product in
             ProductSheetView(data: product)
                 .presentationDetents([.fraction(0.62)])
                 .presentationDragIndicator(Visibility.hidden)
         }
         
     }

     private var searchBar: some View {
         HStack {
             if isSearching {
                 Button(action: {
                     isSearching = false
                     searchText = ""
                     viewModel.searchResults = nil
                 }) {
                     Icon.backBtn.image
                         .foregroundStyle(Color.gray900)
                 }
             }
             HStack{
                 if !isSearching {
                     Icon.glass.image
                 }
                 TextField(isSearching ? "" : "검색어를 입력하세요", text: $searchText)
                     .onSubmit {
                         Task {
                             await performSearch()
                         }
                     }
             }
             .frame(width: 325, height: 24)
             .padding(.horizontal, 12)
             .padding(.vertical, 8)
             .background(Color.white)
             .clipShape(RoundedRectangle(cornerRadius: 20))
             .overlay(RoundedRectangle(cornerRadius: 20)
                 .stroke(Color.gray200, lineWidth: 1))
             .onTapGesture {
                 isSearching = true
             }
         }
         .padding(.top, isSearching ? 0 : 1)
     }
     
     private func performSearch() async {
         // 검색을 실제로 실행하는 로직을 여기에 구현합니다.
         print("검색 실행: \(searchText)")
         await viewModel.performSearch(for: searchText)
         // 검색 결과를 나타내는 뷰를 업데이트하려면 isSearching 상태를 true로 설정
         isSearching = true
     }
    
    
    private var Contents: some View {
        VStack(spacing: 24) {
            categorySegmentedControl
                .padding(.top, 6)
            
            if viewModel.selectedCategory == .all {
                aiProductSet
                    .padding(.top, -10)
            }
            productSet
            Spacer()
        }
    }
    
    
    
    private var categorySegmentedControl: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(RecommendProductSegment.allCases, id: \.self) { category in
                    Button(action: {
                        viewModel.selectedCategory = category
                        Task {
                            if category == .all {
                                await viewModel.getAllProducts()
                            } else {
                                // await viewModel.getCategoryProducts(for: category.rawValue)
                            }
                        }
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
            .padding(.horizontal, 25)
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
                                .onTapGesture {
                                    selectedProduct = product
                                }
                        }
                    }
                    .padding(.horizontal, 21)
                }
            }
        }
    }
    
    private var productSet: some View {
        VStack(spacing: 16){
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
            let productsToShow = viewModel.selectedCategory == .all ? viewModel.products : viewModel.categoryProducts
            ForEach(productsToShow) { product in
                RecommendProduct(
                    data: product,
                    rank: productsToShow.firstIndex(of: product) ?? 0
                )
                .onTapGesture {
                    selectedProduct = product
                }
            }
        }
        .padding(.horizontal, 21)
    }
}



//MARK: - Preview
struct SuggestionInitialView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro", "iPhone 15 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            SuggestionInitialView(viewModel: SuggestionViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
