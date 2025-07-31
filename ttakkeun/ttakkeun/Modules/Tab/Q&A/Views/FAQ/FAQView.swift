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
        static let topRowHspacing: CGFloat = 16
        static let rowCount: Int = 1
        static let topText: String = "자주 묻는 질문 Top 10"
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(spacing: 25, content: {
                topTenQuestionGroup
                
                Divider()
                    .frame(height: 1)
                    .foregroundStyle(Color.listDivde)
                
                faqList
            })
            .padding(.top ,10)
            .padding(.bottom, 100)
        })
    }
    
    // MARK: - Group
    
    private var topTenQuestionGroup: some View {
        ZStack(alignment: .top, content: {
            VStack(alignment: .leading, spacing: -8, content: {
                topTenQuestionTitle
                    .zIndex(1)
                topTenQuestionList
            })
        })
    }
    
    private var faqList: some View {
        VStack(spacing: 20, content: {
            fiveCategoryButton
            categoryQnAList
        })
    }
    
    // MARK: - TOP10 Question
    
    /// 상단 Top10 질문 텍스트
    private var topTenQuestionTitle: some View {
        HStack(spacing: 9, content: {
            Image(.profileCat)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FAQConstants.profileCatWidth, height: FAQConstants.profileCatHeight)
            
            Text(FAQConstants.topText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
        })
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
    }
    
    // MARK: - CategoryList
    private var fiveCategoryButton: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(115), spacing: 20), count: 3), spacing: 11, content: {
            ForEach(PartItem.allCases, id: \.self) { category in
                makeListButton(category)
            }
        })
    }
    
    private var categoryQnAList: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            ForEach(viewModel.filteredCategoryItems) { item in
                FAQItemView(question: item.question,
                            answer: item.answer,
                            isExpanded: expandedQuestionIds.contains(item.id),
                            onToggle: {
                    if expandedQuestionIds.contains(item.id) {
                        expandedQuestionIds.remove(item.id)
                    } else {
                        expandedQuestionIds.insert(item.id)
                    }
                })
            }
        })
    }
    
}

extension FAQView {
    func makeListButton(_ category: PartItem) -> some View {
        Button(action: {
            viewModel.selectedCategory = category
        }, label: {
            Text(category.toKorean())
                .frame(width: 25, height: 18)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
                .padding(.vertical, 12.5)
                .padding(.horizontal, 39.5)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.selectedCategory == category ? category.toColor() : Color.searchBg)
                }
        })
    }
}

struct FAQView_Preview: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
