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
    
    let padding: CGFloat = 20
    
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(spacing: 24, content: {
                TopStatusBar()
                
                topController
                
                if viewModel.selectedCategory == .all {
                    aiRecommendGroup
                    
                }
                
                Spacer().frame(height: 2)
                
                rankRecommendGroup
                
            })
            .padding(.bottom, 80)
        })
        .matchedGeometryEffect(id: "aiRecommendGroup", in: animationNamespace)
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        }
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
            AIRecommendTitle(padding: padding, title: "따끈따끈 AI 최근 추천")
            recommendProducts
        })
    }
    
    @ViewBuilder
    private var recommendProducts: some View {
        if !viewModel.aiProducts.isEmpty {
            ScrollView(.horizontal, content: {
                HStack(spacing: 10, content: {
                    ForEach($viewModel.aiProducts, id: \.self) { data in
                        RecentRecommendation(data: data, type: .localDB)
                    }
                })
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
    }
    
    private var rankRecommendedProducts: some View {
        VStack(spacing: 16, content: {
            if !viewModel.recommendProducts.isEmpty  {
                ForEach(Array(viewModel.recommendProducts.enumerated()), id: \.offset) { index, product in
                    RankRecommendation(data: $viewModel.recommendProducts[index], rank: index)
                }
            } else {
                ProgressView {
                    Text("추천 상품을 받아오는 중입니다. \n잠시만 기다려 주세요!")
                        .multilineTextAlignment(.center)
                        .lineSpacing(2.5)
                        .font(.Body3_medium)
                }
                .controlSize(.large)
                .padding(.vertical, 31)
                .padding(.horizontal, 85)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray300, lineWidth: 1)
                }
            }
        })
        .padding(.horizontal, 4.5)
    }
    
}

extension RecommendView {
    func makeButton(part: ExtendPartItem) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                viewModel.selectedCategory = part
            }
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
}

struct RecommendView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendView(container: DIContainer())
            .environmentObject(DIContainer())
            .environmentObject(AppFlowViewModel())
    }
}
