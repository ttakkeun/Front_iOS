//
//  HomeAI.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeAIProduct: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeRecommendViewModel
    @AppStorage(AppStorageKey.petName) var petName: String = ""
    
    // MARK: Constants
    fileprivate enum HomeAIProductConstants {
        static let mainVspacing: CGFloat = 16
        static let contentsHspacng: CGFloat = 12
        static let cardPrefix: Int = 8
        
        static let notPetName: String = "따끈 따끈 AI 추천 제품"
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: HomeAIProductConstants.mainVspacing, content: {
            topTitle
            if !viewModel.aiProduct.isEmpty {
                bottomContents
            } else {
                NotRecommend(recommendType: .aiRecommend)
            }
        })
    }
    
    // MARK: - TopContents
    /// 섹션 타이틀
    private var topTitle: some View {
        Text("\(petName)를 위한 따끈 따끈 AI 추천 제품")
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    // MARK: - BottomContents
    /// AI 상품 있는 경우
    private var bottomContents: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: HomeAIProductConstants.contentsHspacng, content: {
                ForEach(viewModel.aiProduct.prefix(HomeAIProductConstants.cardPrefix), id: \.id) { data in
                    AIRecommendProductCard(data: data)
                }
            })
            .fixedSize()
        })
        .contentMargins(.bottom, UIConstants.horizonScrollBottomPadding, for: .scrollContent)
    }
}

struct HomeAIProductt_Preview: PreviewProvider {
    static var previews: some View {
        HomeAIProduct(viewModel: HomeRecommendViewModel(container: DIContainer()))
    }
}
