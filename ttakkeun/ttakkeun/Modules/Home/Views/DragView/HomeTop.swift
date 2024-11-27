//
//  HomeTop.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeTop: View {
    
    @StateObject var viewModel: HomeRecommendViewModel
    let petType: ProfileType?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Group {
                if let type = petType {
                    Text("\(type.forProcutCard()) \(UserState.shared.getPetName())를 위한 추천 제품 TOP8")
                } else {
                    Text("\(UserState.shared.getPetName())를 위한 추천 제품 TOP8")
                }
            }
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            if let resultData = viewModel.userProduct {
                ScrollView(.horizontal, content: {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(90), spacing: 12), count: 4), spacing: 11, content: {
                        ForEach(Array(resultData.prefix(8).enumerated()), id: \.element) { index, data in
                            UserRecommendProductCard(data, index)
                        }
                    })
                    .frame(width: 354, height: 331)
                    .padding(.bottom, 80)
                    .padding(.leading, 12)
                })
            } else {
                HStack {
                    NotRecommend(recommendType: .userRecommend)
                }
            }
        })
    }
}

struct HomeTop_Preview: PreviewProvider {
    static var previews: some View {
        HomeTop(viewModel: HomeRecommendViewModel(), petType: .cat)
    }
}
