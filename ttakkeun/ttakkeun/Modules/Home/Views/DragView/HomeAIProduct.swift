//
//  HomeAI.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeAIProduct: View {
    
    @StateObject var viewModel: HomeRecommendViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("\(UserState.shared.getPetName())를 위한 따끈 따끈 AI 추천 제품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            if let resultData = viewModel.aiProduct {
                if !resultData.isEmpty {
                    ScrollView(.horizontal, content: {
                        HStack(spacing: 12) {
                            ForEach(resultData.prefix(8), id: \.self) { data in
                                AIRecommendProductCard(data: data)
                            }
                        }
                        .frame(height: 92)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 10)
                    })
                    .scrollIndicators(.visible)
                } else {
                    empyetView
                }
            } else {
                empyetView
            }
        })
    }
    
    private var empyetView: some View {
        HStack {
            
            Spacer()
            
            NotRecommend(recommendType: .aiRecommend)
            
            Spacer()
        }
    }
}

struct HomeAIProductt_Preview: PreviewProvider {
    static var previews: some View {
        HomeAIProduct(viewModel: HomeRecommendViewModel(container: DIContainer()))
    }
}
