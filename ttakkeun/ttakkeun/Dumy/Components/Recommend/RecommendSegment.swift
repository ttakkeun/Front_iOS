//
//  RecommendSegment.swift
//  ttakkeun
//
//  Created by 한지강 on 8/20/24.
//

import SwiftUI

/// 추천탭에 있는 커스텀 세그먼티드 컨트롤
struct RecommendSegment: View {
    //TODO: - 뷰모델에 넣고 selectedCategory는 viewModel.selectedCategory로 바꾸고 관리하면 됨
    @State private var selectedCategory: RecommendProductSegment = .all
    
    //TODO: - 버튼으로 selectedCategory를 바꿈 -> 그래서 선택된 카테고리를 띄우면 됨
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(RecommendProductSegment.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        print(category.toKorean())
                    }) {
                        Text(category.toKorean())
                            .frame(width: 40, height: 20, alignment: .center)
                            .font(.Body2_medium)
                            .foregroundStyle(Color.gray900)
                            .foregroundColor(selectedCategory == category ? .white : .black)
                            .padding(.horizontal, 18.5)
                            .padding(.vertical, 8)
                            .background(
                            RoundedRectangle(cornerRadius: 999)
                             .stroke(Color.gray600, lineWidth: 2.5))
                            .background(selectedCategory == category ? Color.primarycolor_200 : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius:999))
                    }
                }
            }
            .padding(.horizontal, 19)
        }
    }
}

//MARK: - Preview
struct RecommendProductSegmentView_Preview: PreviewProvider {
    static var previews: some View {
        RecommendSegment()
            .previewLayout(.sizeThatFits)
    }
}
