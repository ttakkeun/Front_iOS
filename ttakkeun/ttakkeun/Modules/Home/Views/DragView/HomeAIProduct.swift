//
//  HomeAI.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeAIProduct: View {
    
    @StateObject var viewModel: RecommendViewModel = RecommendViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("\(UserState.shared.getPetName())를 위한 따끈 따끈 AI 추천 제품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            if let resultData = viewModel.aiProduct {
                ScrollView(.horizontal, content: {
                    LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 241)), count: 1), spacing: 12, content: {
                        ForEach(resultData.prefix(8), id: \.self) { data in
                            AIRecommendProductCard(data: data)
                        }
                    })
                    .frame(height: 92)
                    .padding(.horizontal, 5)
                })
                .scrollIndicators(.visible)
            } else {
                HStack {
                    
                    NotRecommend(recommendType: .aiRecommend)
                }
            }
        })
    }
}

struct HomeAIProductt_Preview: PreviewProvider {
    static var previews: some View {
        HomeAIProduct(viewModel: RecommendViewModel())
    }
}
