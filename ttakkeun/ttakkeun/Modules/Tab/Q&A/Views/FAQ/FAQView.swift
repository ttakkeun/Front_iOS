//
//  FAQView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct FAQView: View {
    
    // MARK: - Property
    @State var viewModel: FAQViewModel = .init()
    @State private var expandedQuestionIds: Set<UUID> = []
    
    // MARK: - Constants
    fileprivate enum FAQConstants {
        static let profileCatWidth: CGFloat = 67
        static let profileCatHeight: CGFloat = 56
        static let categoryHeight: CGFloat = 43
        
        static let contentsVspacing: CGFloat = 25
        static let middleVpspacing: CGFloat = 20
        static let middleAnswerSpacing: CGFloat = 10
        static let gridVspacing: CGFloat = 11
        static let topRowHspacing: CGFloat = 16
        static let topTenQuestionHspacing: CGFloat = 9
        static let cornerRadius: CGFloat = 10
        static let columsCount: Int = 3
        static let rowCount: Int = 1
        static let zIndex: Double = 1
        static let yOffset: Double = 3
        static let topText: String = "자주 묻는 질문 Top 10"
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(spacing: FAQConstants.contentsVspacing, content: {
                topContents
                Divider()
                    .foregroundStyle(Color.listDivde)
                middleContents
            })
            .padding(.bottom, UIConstants.horizonScrollBottomPadding)
        })
        .contentMargins(.top, UIConstants.topScrollPadding, for: .scrollContent)
    }
    
    // MARK: - TopContents
    /// 상단 컨텐츠
    private var topContents: some View {
        ZStack(alignment: .top, content: {
            VStack(alignment: .leading, spacing: .zero, content: {
                topTenQuestionTitle
                    .zIndex(FAQConstants.zIndex)
                topTenQuestionList
                    .offset(y: -FAQConstants.yOffset)
            })
        })
    }
    
    /// 상단 Top10 질문 텍스트
    private var topTenQuestionTitle: some View {
        HStack(spacing: FAQConstants.topTenQuestionHspacing, content: {
            Image(.profileCat)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FAQConstants.profileCatWidth, height: FAQConstants.profileCatHeight)
            
            Text(FAQConstants.topText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
        })
        .padding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    /// Top10 질문 리스트
    @ViewBuilder
    private var topTenQuestionList: some View {
        let rows = Array(repeating: GridItem(.flexible()), count: FAQConstants.rowCount)
        ScrollView(.horizontal, content: {
            LazyHGrid(rows: rows, spacing: FAQConstants.topRowHspacing, content: {
                ForEach(Array($viewModel.topTenQuestions.enumerated()), id: \.element.id) { index, question in
                    TopTenQuestionCard(data: question, index: index)
                }
            })
        })
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
        .contentMargins(.bottom, UIConstants.horizonScrollBottomPadding, for: .scrollContent)
    }
    
    // MARK: - MiddleContents
    /// 중간 컨텐츠
    private var middleContents: some View {
        VStack(spacing: FAQConstants.middleVpspacing, content: {
            fiveCategoryButton
            categoryQnAList
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    /// 카테고리 버튼
    @ViewBuilder
    private var fiveCategoryButton: some View {
        let colums = Array(repeating: GridItem(.flexible(), spacing: FAQConstants.gridVspacing), count: FAQConstants.columsCount)
        
        LazyVGrid(columns: colums, spacing: FAQConstants.gridVspacing, content: {
            ForEach(PartItem.allCases, id: \.self) { category in
                makeListButton(category)
            }
        })
    }
    
    /// 카테고리 개별 컨텐츠 버튼
    /// - Parameter category: 파트 타입
    /// - Returns: 버튼 반환
    func makeListButton(_ category: PartItem) -> some View {
        Button(action: {
            viewModel.selectedCategory = category
        }, label: {
            categoryContents(category)
        })
    }
    
    /// 카테고리 개별 컴포넌트
    private func categoryContents(_ category: PartItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: FAQConstants.cornerRadius)
                .fill(viewModel.selectedCategory == category ? category.toColor() : Color.searchBg)
                .frame(maxWidth: .infinity, minHeight: FAQConstants.categoryHeight)
            
            Text(category.toKorean())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
        }
    }
    
    /// 카테고리 리스트
    private var categoryQnAList: some View {
        LazyVStack(spacing: FAQConstants.middleAnswerSpacing, content: {
            ForEach(Array(viewModel.filteredCategoryItems.enumerated()), id: \.offset) { index, item in
                FAQItemView(
                    data: item,
                    isExpanded: expandedQuestionIds.contains(item.id),
                    onToggle: {
                        onToggleActoin(item)
                    })
                
                if index < viewModel.filteredCategoryItems.count - 1 {
                    Divider()
                        .foregroundStyle(Color.gray300)
                }
            }
        })
        .frame(maxWidth: .infinity)
    }
    
    private func onToggleActoin(_ item: FAQData) {
        if expandedQuestionIds.contains(item.id) {
            expandedQuestionIds.remove(item.id)
        } else {
            expandedQuestionIds.insert(item.id)
        }
    }
}

struct FAQView_Preview: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
