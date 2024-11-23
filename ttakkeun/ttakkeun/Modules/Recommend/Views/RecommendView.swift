//
//  RecommendView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import SwiftUI

struct RecommendView: View {
    
    @StateObject var viewModel: RecommendationViewModel = .init()
    @Namespace private var animationNamespace
    
    let padding: CGFloat = 25
    
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(spacing: 17, content: {
                TopStatusBar()
                
                topController
                
                if viewModel.productViewModel.selectedCategory == .all {
                    Spacer().frame(height: 2)
                    aiRecommendGroup
                    
                }
                
                Spacer().frame(height: 2)
                
                rankRecommendGroup
                
            })
            .padding(.bottom, 80)
        })
        .matchedGeometryEffect(id: "aiRecommendGroup", in: animationNamespace)
    }
    
    // MARK: -Top Controller
    
    private var topController: some View {
        VStack(alignment: .center, spacing: 17, content: {
            Button(action: {
                viewModel.searachViewModel.isSearchActive.toggle()
            }, label: {
                CustomTextField(text: $viewModel.searachViewModel.searchText, placeholder: "검색어를 입력해주세요.", cornerRadius: 20, showGlass: true, maxWidth: 360, maxHeight: 40)
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
            aiRecommendTitle
            recommendProducts
        })
    }
    
    private var aiRecommendTitle: some View {
        HStack(spacing: 4, content: {
            
            Icon.recommendDog.image
                .fixedSize()
            Text("따끈따끈 AI 최근 추천")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
        })
        .padding(.leading, padding)
    }
    
    @ViewBuilder
    private var recommendProducts: some View {
        if let datas = viewModel.productViewModel.aiProducts {
            ScrollView(.horizontal, content: {
                HStack(spacing: 10, content: {
                    ForEach(datas.prefix(10), id: \.self) { data in
                        RecentRecommendation(data: data)
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
            
            rankRecommendedProducts
        })
    }
    
    private var rankRecommendedProducts: some View {
        VStack(spacing: 16, content: {
            if !viewModel.productViewModel.recommendProducts.isEmpty  {
                ForEach(Array(viewModel.productViewModel.recommendProducts.enumerated()), id: \.offset) { index, product in
                    RankRecommendation(data: $viewModel.productViewModel.recommendProducts[index], rank: index)
                }
            } else {
                Spacer()
                
                ProgressView {
                    LoadingDotsText(text: "추천 상품을 받아오는 중입니다. 잠시만 기다려 주세요!")
                }
                .controlSize(.large)
                
                Spacer()
            }
        })
        .padding(.horizontal, 4.5)
    }
    
}

extension RecommendView {
    func makeButton(part: ExtendPartItem) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                viewModel.productViewModel.selectedCategory = part
            }
        }, label: {
            Text(part.toKorean())
                .frame(width: 28, height: 20)
                .padding(.vertical, 6)
                .padding(.horizontal, 24)
                .font(.Body2_medium)
                .foregroundStyle(viewModel.productViewModel.selectedCategory == part ? Color.gray900 : Color.gray600)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(viewModel.productViewModel.selectedCategory == part ? Color.primarycolor200 : Color.clear)
                        .stroke(Color.gray700, lineWidth: 1)
                }
        })
    }
}

struct RecommendView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}
