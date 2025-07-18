//
//  RecommendView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI

/// 상품 추천 뷰
struct RecommendView: View {
    
    // MARK: - Property
    @State var viewModel: RecommendationProductViewModel
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @Namespace private var animationNamespace
    
    // MARK: - Constants
    fileprivate enum RecommendConstants {
        static let contentsVspacing: CGFloat = 24
        static let topContentsVspacing: CGFloat = 17
        static let topSegmentHspacing: CGFloat = 8
        static let recommendProductHspacing: CGFloat = 10
        
        static let textFieldHorizonPadding: CGFloat = 12
        static let textFieldVerticalPadding: CGFloat = 8
        static let lineSpacing: CGFloat = 2.5
        
        static let sheetCornerRadiust: CGFloat = 30
        static let sheetHeight: CGFloat = 540
        
        static let buttonWidth: CGFloat = 28
        static let buttonHeight: CGFloat = 20
        static let buttonVertical: CGFloat = 6
        static let buttonHorizon: CGFloat = 24
        static let cornerRadius: CGFloat = 24
        
        static let textFieldCornerRadius: CGFloat = 20
        static let textFieldGlassSize: CGFloat = 24
        static let placeholderText: String = "검색어를 입력하세요"
        static let loadingAIProducts: String = "최근 AI 제품을 받아오는 중입니다...!"
        static let recommendTitle: String = "따끈따끈 AI 최근 추천"
        static let searchPlaceholder: String = "검색어를 입력하세요"
        static let rankTitleText: String = "랭킹별 추천 상품"
        static let loadingRecommendText: String = "추천 상품을 받아오는 중입니다. \n잠시만 기다려 주세요!"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: RecommendConstants.contentsVspacing, content: {
            TopStatusBar()
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
                .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
            
            contents
        })
        .background(Color.white)
        .sheet(item: $viewModel.selectedData, onDismiss: {
            viewModel.selectedData = nil
        }, content: { item in
            ProductSheetView(
                data: sheetBinding(product: item),
                action: {
                    viewModel.likeProduct(productId: item.productId, productData: viewModel.makeLikePatchRequest(data: item))
                })
            .presentationDetents([.height(RecommendConstants.sheetHeight)])
            .presentationDragIndicator(Visibility.hidden)
            .presentationCornerRadius(RecommendConstants.sheetCornerRadiust)
        })
        //TODO: - API 연결 시 해제
//        .task {
//            viewModel.getAIProucts()
//        }
//        .onChange(of: viewModel.selectedCategory, {
//            loadInitialData()
//        })
//        .task {
//            loadInitialData()
//        }
    }
    
    // MARK: - Contents
    private var contents: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: RecommendConstants.contentsVspacing, content: {
                topContents
                if viewModel.selectedCategory == .all {
                    aiRecommendGroup
                }
                rankRecommendGroup
            })
        })
        .contentMargins(.bottom, UIConstants.safeBottom, for: .scrollContent)
    }
    
    // MARK: - TopContents
    /// 상단 검색 및 세그먼트 버튼
    private var topContents: some View {
        VStack(alignment: .leading, spacing: RecommendConstants.topContentsVspacing, content: {
            textField
            topSegments
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    /// 상단 세그먼트 버튼
    private var topSegments: some View {
        ScrollView(.horizontal, content: {
            HStack(spacing: RecommendConstants.topSegmentHspacing, content: {
                ForEach(ExtendPartItem.allCases, id: \.self) { part in
                    makeButton(part: part)
                }
            })
        })
        .contentMargins(.vertical, UIConstants.topScrollPadding, for: .scrollContent)
        .scrollIndicators(.hidden)
    }
    
    /// 텍스트 필드
    private var textField: some View {
        HStack {
            Image(.glass)
                .resizable()
                .frame(width: RecommendConstants.textFieldGlassSize, height: RecommendConstants.textFieldGlassSize)
            
            TextField(RecommendConstants.searchPlaceholder, text: .constant(""))
                .disabled(true)
            
            Spacer()
        }
        .padding(.vertical, RecommendConstants.textFieldVerticalPadding)
        .padding(.horizontal, RecommendConstants.textFieldHorizonPadding)
        .background {
            RoundedRectangle(cornerRadius: RecommendConstants.textFieldCornerRadius)
                .fill(Color.white)
                .stroke(Color.gray200, style: .init())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.goToSearchView()
        }
    }
    
    /// 텍스트 필드
    private var placeholder: Text {
        Text(RecommendConstants.placeholderText)
            .font(.Body2_medium)
            .foregroundStyle(Color.gray200)
    }
    
    // MARK: - AI Recommend
    @ViewBuilder
    private var aiRecommendGroup: some View {
        VStack(alignment: .leading, spacing: .zero, content: {
            AIRecommendTitle(title: RecommendConstants.recommendTitle)
            
            if !viewModel.isLoadingAIProduct {
                recommendProducts
            } else {
                loadingProducts
            }
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    /// 상품 로딩 컴포넌트
    private var loadingProducts: some View {
        HStack {
            Spacer()
            ProgressView(label: {
                Text(RecommendConstants.loadingAIProducts)
                    .controlSize(.regular)
            })
            Spacer()
        }
    }
    
    /// 추천 상 품 여부
    @ViewBuilder
    private var recommendProducts: some View {
        if !viewModel.aiProducts.isEmpty {
            existRecommendProduct
        } else {
            NotRecommend(recommendType: .aiRecommend)
        }
    }
    
    /// 추천 상품 존재할 경우, 스크롤
    private var existRecommendProduct: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: RecommendConstants.recommendProductHspacing, content: {
                ForEach($viewModel.aiProducts, id: \.id) { $data in
                    RecentRecommendCard(data: $data, type: .localDB, action: {
                        viewModel.likeProduct(
                            productId: data.productId,
                            productData: viewModel.makeLikePatchRequest(data: data)
                        )
                    })
                    .handleTapGesture(with: viewModel, data: data, source: .aiProduct)
                }
            })
            .fixedSize()
        })
        .contentMargins(.vertical, UIConstants.topScrollPadding, for: .scrollContent)
    }
    
    // MARK: - Rank Recommend
    /// 랭킹병 추천 상품
    private var rankRecommendGroup: some View {
        VStack(alignment: .leading, spacing: RecommendConstants.topContentsVspacing, content: {
            Text(RecommendConstants.rankTitleText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            existRankRecommend
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    @ViewBuilder
    private var existRankRecommend: some View {
        let array = Array($viewModel.recommendProducts.enumerated())
        
        LazyVStack(spacing: RecommendConstants.contentsVspacing, content: {
            ForEach(array, id: \.offset) { index, product in
                RankRecommendCard(data: $viewModel.recommendProducts[index],
                                  rank: index,
                                  action: {
                    viewModel.likeProduct(
                        productId: viewModel.recommendProducts[index].productId,
                        productData: viewModel.makeLikePatchRequest(data: viewModel.recommendProducts[index])
                    )
                })
                .handleTapGesture(with: viewModel, data: viewModel.recommendProducts[index], source: .userProduct)
                .task {
                    rankCardTaskAction(product: product)
                }
            }
            
            if viewModel.isLoadingUserProduct || viewModel.isLoadingRankTagProduct {
                ProgressView()
                    .controlSize(.regular)
            }
        })
        .fixedSize()
    }
    
    /// 랭크별 아이템 액션
    /// - Parameter product: 랭크별 개별 아이템
    private func rankCardTaskAction(product: Binding<ProductResponse>) {
        if product.wrappedValue.id == viewModel.recommendProducts.last?.id && viewModel.canLoadMoarUserProduct {
            if viewModel.selectedCategory == .all {
                viewModel.getUserRecommendAll(page: viewModel.userProductPage)
            } else {
                viewModel.getUserRecommendTag(tag: viewModel.selectedCategory.toPartItemRawValue() ?? "EAR", page: viewModel.userProductPage)
            }
        }
    }
}

extension RecommendView {
    /// 세그먼트 생성 버튼
    /// - Parameter part: 세그먼트 내부 아이템
    /// - Returns: 버튼 반환
    func makeButton(part: ExtendPartItem) -> some View {
        Button(action: {
            viewModel.selectedCategory = part
        }, label: {
            Text(part.toKorean())
                .frame(width: RecommendConstants.buttonWidth, height: RecommendConstants.buttonHeight)
                .padding(.vertical, RecommendConstants.buttonVertical)
                .padding(.horizontal, RecommendConstants.buttonHorizon)
                .font(.Body2_medium)
                .foregroundStyle(viewModel.selectedCategory == part ? Color.gray900 : Color.gray600)
                .background {
                    RoundedRectangle(cornerRadius: RecommendConstants.cornerRadius)
                        .fill(viewModel.selectedCategory == part ? Color.primarycolor200 : Color.clear)
                        .stroke(Color.gray700, style: .init())
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
    
    /// 상품 시트뷰 바인딩
    /// - Parameter product: 시트뷰로 선택된 상품
    /// - Returns: 상품 정보 반환
    func sheetBinding(product: ProductResponse) -> Binding<ProductResponse> {
        return Binding(
            get: { product },
            set: { updateProduct in
                viewModel.updateProduct(product)
            }
        )
    }
}

struct RecommendView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendView(container: DIContainer())
            .environmentObject(DIContainer())
            .environmentObject(AppFlowViewModel())
    }
}

