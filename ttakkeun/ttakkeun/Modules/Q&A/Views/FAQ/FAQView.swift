//
//  FAQView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct FAQView: View {
    
    @StateObject var viewModel: FAQViewModel = .init()
    @State private var expandedQuestionIds: Set<UUID> = []
    
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(content: {
                topTenQuestionGroup
                
                Divider()
                    .frame(height: 1)
                    .foregroundStyle(Color.listDivde)
                
                faqList
            })
            .padding(.bottom, 110)
        })
    }
    
    // MARK: - Group
    
    private var topTenQuestionGroup: some View {
        ZStack(alignment: .top, content: {
            VStack(alignment: .leading, spacing: -8, content: {
                topTenQuestionTitle
                    .zIndex(1)
                    .padding(.leading, 25)
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
    
    private var topTenQuestionTitle: some View {
        HStack(spacing: 9, content: {
            Icon.profileCat.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 67, height: 56)
            
            Text("자주 묻는 질문 Top 10")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
        })
    }
    
    private var topTenQuestionList: some View {
        ScrollView(.horizontal, content: {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 160, maximum: 180)), count: 1), spacing: 16, content: {
                ForEach(Array($viewModel.topTenQuestions.enumerated()), id: \.element.id) { index, question in
                    TopTenQuestionCard(data: question, index: index)
                }
            })
            .padding(.horizontal, 14)
        })
        .frame(height: 156)
        .padding(.vertical, 4)
    }
    
    // MARK: - CategoryList
    private var fiveCategoryButton: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(105)), count: 3), spacing: 11, content: {
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
