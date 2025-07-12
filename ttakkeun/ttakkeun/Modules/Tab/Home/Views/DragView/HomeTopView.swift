//
//  HomeTop.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeTop: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeRecommendViewModel
    @AppStorage(AppStorageKey.petName) var petName: String = ""
    let petType: ProfileType
    
    // MARK: - Constants
    fileprivate enum HomeTopConstants {
        static let gridSpacing: CGFloat = 11
        static let columnSpacing: CGFloat = 6
        static let columnsCount: Int = 4
        static let prefixCount: Int = 8
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            topText
            if !viewModel.userProduct.isEmpty {
                bottomContents
            } else {
                NotRecommend(recommendType: .userRecommend)
            }
        })
    }
    
    // MARK: - TopContents
    private var topText: some View {
        Text("\(petType.forProcutCard()) \(petName)를 위한 추천 제품 TOP8")
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    // MARK: - BottomContents
    @ViewBuilder
    private var bottomContents: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: HomeTopConstants.columnSpacing), count: HomeTopConstants.columnsCount)
        
        LazyVGrid(columns: columns, spacing: HomeTopConstants.gridSpacing, content: {
            ForEach(Array(viewModel.userProduct.prefix(HomeTopConstants.prefixCount).enumerated()), id: \.element) { index, data in
                UserRecommendProductCard(data, index)
            }
        })
    }
}

#Preview {
    HomeTop(viewModel: .init(container: DIContainer()), petType: .cat)
}
