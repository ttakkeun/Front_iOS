//
//  RecommendView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI

struct RecommendView: View {
    
    @StateObject var viewModel: RecommendationProductViewModel
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @Namespace private var animationNamespace
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    let padding: CGFloat = 34
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            TopStatusBar()
            ScrollView(.vertical, content: {
                
                VStack(spacing: 24, content: {
                    
                    topController
                    
                    if viewModel.selectedCategory == .all {
                        aiRecommendGroup
                    }
                    
                    rankRecommendGroup
                    
                })
                .padding(.top, 8)
                .padding(.bottom, 110)
            })
        })
        .background(Color.scheduleBg)
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        }
        .sheet(isPresented: $viewModel.isShowSheetView, content: {
            if let product = viewModel.selectedData {
                ProductSheetView(data: Binding(get: { product },
                                               set: { updateProduct in
                    viewModel.updateProduct(updateProduct)
                }), isShowSheet: $viewModel.isShowSheetView, action: { viewModel.likeProduct(productId: product.productId, productData: viewModel.makeLikePatchRequest(data: product)) })
                .presentationDetents([.fraction(0.68)])
                .presentationDragIndicator(Visibility.hidden)
                .presentationCornerRadius(30)
            }
        })
        .overlay(alignment: .center, content: {
            if viewModel.isLoadingSheetView {
                ProgressView()
                    .controlSize(.large)
                    .transition(.opacity)
            }
        })
    }
    
    // MARK: - Top Controller
    
    private var topController: some View {
        VStack(alignment: .center, spacing: 17, content: {
            Button(action: {
                viewModel.goToSearchView()
            }, label: {
                CustomTextField(text: .constant(""), placeholder: "검색어를 입력해주세요.", cornerRadius: 20, showGlass: true, maxWidth: 360, maxHeight: 40)
                    .disabled(true)
            })
            
            
            topSegmentedControl
        })
        .padding(.top, 10)
    }
    
    private var topSegmentedControl: some View {
        ScrollView(.horizontal, content: {
            HStack(spacing: 8, content: {
                ForEach(ExtendPartItem.allCases, id: \.self) { part in
                    makeButton(part: part)
                }
            })
            .padding(.horizontal, padding)
            .padding(.vertical, 5)
        })
        .scrollIndicators(.hidden)
    }
    
    // MARK: - AI Recommend
    
    @ViewBuilder
    private var aiRecommendGroup: some View {
        VStack(alignment: .leading, spacing: -1, content: {
            AIRecommendTitle(padding: viewModel.aiProducts.isEmpty ? 34 : padding, title: "따끈따끈 AI 최근 추천")
            if !viewModel.isLoadingAIProduct {
                recommendProducts
            } else {
                HStack {
                    Spacer()
                    
                    ProgressView(label: {
                        Text("최근 AI 제품을 받아오는 중입니다.")
                            .controlSize(.regular)
                    })
                    
                    Spacer()
                }
            }
        })
        .task {
            viewModel.getAIProucts()
        }
    }
    
    @ViewBuilder
    private var recommendProducts: some View {
        if !viewModel.aiProducts.isEmpty {
            ScrollView(.horizontal, content: {
                HStack(spacing: 10, content: {
                    ForEach($viewModel.aiProducts, id: \.id) { $data in
                        RecentRecommendation(data: $data, type: .localDB, action: { viewModel.likeProduct(productId: data.productId, productData: viewModel.makeLikePatchRequest(data: data)) })
                            .handleTapGesture(with: viewModel, data: data, source: .aiProduct)
                    }
                })
                .padding(.bottom, 10)
                .padding(.horizontal, padding)
            })
        } else {
            NotRecommend(recommendType: .aiRecommend)
        }
    }
    
    // MARK: - Rank Recommend
    
    private var rankRecommendGroup: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("랭킹별 추천 상품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
                .padding(.leading, padding)
            
            rankRecommendedProducts
        })
        .frame(maxWidth: .infinity)
    }
    
    private var rankRecommendedProducts: some View {
        VStack(spacing: 32, content: {
            if !viewModel.recommendProducts.isEmpty  {
                ForEach(Array(viewModel.recommendProducts.enumerated()), id: \.offset) { index, product in
                    RankRecommendation(data: $viewModel.recommendProducts[index], rank: index, action: { viewModel.likeProduct(productId: viewModel.recommendProducts[index].productId, productData: viewModel.makeLikePatchRequest(data: viewModel.recommendProducts[index])) } )
                        .handleTapGesture(with: viewModel, data: viewModel.recommendProducts[index], source: .userProduct)
                        .task {
                            if product == viewModel.recommendProducts.last && viewModel.canLoadMoarUserProduct {
                                if viewModel.selectedCategory == .all {
                                    viewModel.getUserRecommendAll(page: viewModel.userProductPage)
                                } else {
                                    viewModel.getUserRecommendTag(tag: viewModel.selectedCategory.toPartItemRawValue() ?? "EAR", page: viewModel.userProductPage)
                                }
                            }
                        }
                }
                
                if viewModel.isLoadingUserProduct || viewModel.isLoadingRankTagProduct {
                    ProgressView()
                        .controlSize(.regular)
                }
            } else {
                ProgressView {
                    Text("추천 상품을 받아오는 중입니다. \n잠시만 기다려 주세요!")
                        .multilineTextAlignment(.center)
                        .lineSpacing(2.5)
                        .font(.Body3_medium)
                }
                .controlSize(.regular)
                .modifier(ProductWarningModifier())
            }
        })
        .frame(maxWidth: .infinity)
        .padding(.horizontal, padding)
        .onChange(of: viewModel.selectedCategory, {
            loadInitialData()
        })
        .task {
            loadInitialData()
        }
    }
    
}

extension RecommendView {
    func makeButton(part: ExtendPartItem) -> some View {
        Button(action: {
            viewModel.selectedCategory = part
        }, label: {
            Text(part.toKorean())
                .frame(width: 28, height: 20)
                .padding(.vertical, 6)
                .padding(.horizontal, 24)
                .font(.Body2_medium)
                .foregroundStyle(viewModel.selectedCategory == part ? Color.gray900 : Color.gray600)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(viewModel.selectedCategory == part ? Color.primarycolor200 : Color.clear)
                        .stroke(Color.gray700, lineWidth: 1)
                }
        })
    }
    func loadInitialData() {
        if viewModel.selectedCategory == .all {
            viewModel.startNewUserProductAll()
        } else {
            viewModel.startNewRankTagProducts()
        }
    }
}

struct RecommendView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendView(container: DIContainer())
            .environmentObject(DIContainer())
            .environmentObject(AppFlowViewModel())
    }
}
