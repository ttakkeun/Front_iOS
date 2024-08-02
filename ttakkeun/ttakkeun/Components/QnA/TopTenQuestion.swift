//
//  TopTenQuestion.swift
//  ttakkeun
//
//  Created by 한지강 on 7/27/24.
//

import SwiftUI

struct TopTenQuestion: View {
    
    let data: TopTenQuestionData
    let index: Int
    
    //MARK: - Init
    
    init(data: TopTenQuestionData, index: Int) {
        self.data = data
        self.index = index
    }
    
    //MARK: - Components
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 21) {
            questionAndCategory
            content
            Spacer()
        }
        .frame(width: 136, height: 126)
        .padding(13)
        .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray200)
        )
    }
    
    /// question 번호와 categorySet
    private var questionAndCategory: some View {
        HStack(content: {
            Text("Q\(index + 1).")
                .font(.H4_bold)
            Spacer()
            categorySet
        })
        .frame(maxWidth: 136)
    }
    
    /// Category(Text와 뒷배경까지)
    private var categorySet: some View {
            category
                .font(.Body4_medium)
                .frame(width: 47, height: 23)
                .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(categoryColor))
    }
    
    /// Text
    private var content: some View {
        Text(data.content)
            .font(.Body4_medium)
    }
    
    //MARK: - 카테고리
    
    /// 카테고리 텍스트
    @ViewBuilder
    private var category: some View {
        switch data.category {
        case .ear:
            Text("귀")
        case .eye:
            Text("눈")
        case .hair:
            Text("털")
        case .claw:
            Text("발톱")
        case .teeth:
            Text("이빨")
        }
    }
    
    /// 카테고리 뒷 배경
    private var categoryColor: Color {
        switch data.category {
        case .ear:
            Color.afterEar
        case .eye:
            Color.afterEye
        case .hair:
            Color.afterClaw
        case .claw:
            Color.afterEye
        case .teeth:
            Color.afterTeeth
        }
    }
}

//MARK: - Preview

struct TopTenQuestion_Previews: PreviewProvider {
    static var previews: some View {
        TopTenQuestion(data: TopTenQuestionData(category: .ear, content: "털이 왜 이렇게 빠지는 지 궁금해요 !!"), index: 0)
            .previewLayout(.sizeThatFits)
    }
}
