//
//  TopTenQuestion.swift
//  ttakkeun
//
//  Created by 한지강 on 7/27/24.
//
import SwiftUI

/// FAQ화면 자주 묻는 질문 TOP10에 들어갈 qna두ㅕ 컴포넌트
struct TopTenQuestion: View {
    let data: QnaFaqData
    let index: Int
    
    @State private var isFlipped: Bool = false
    
    //MARK: - Init
    
    init(data: QnaFaqData, index: Int) {
        self.data = data
        self.index = index
    }
    
    //MARK: - Components
    
    var body: some View {
        ZStack {
            if isFlipped {
                    answerCard
                    .zIndex(0)
            } else {
                questionCard
                    .zIndex(0)
            }
        }
        .frame(width: 136, height: 126)
        .padding(13)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isFlipped ? Color.primarycolor100 : Color.white)                .stroke(Color.gray200)
                .rotation3DEffect(
                    .degrees(isFlipped ? -180 : 0),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.1
                )
        )
        .animation(.default, value: isFlipped)
        .onTapGesture {
                isFlipped.toggle()
        }
    }
    
    /// question 컴포넌트
    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 21) {
            questionAndCategory
            question
            Spacer()
        }
    }
    
    /// answer 컴포넌트
    private var answerCard: some View {
        VStack(alignment: .leading, spacing: 21) {
            answerAndCategory
            answer
            Spacer()
        }
        
    }
    
    /// question 번호와 category
    private var questionAndCategory: some View {
        HStack(content: {
            Text("Q\(index + 1).")
                .font(.H4_bold)
            Spacer()
            categorySet
        })
        .frame(maxWidth: 136)
    }
    
    /// answer 번호와 category
    private var answerAndCategory: some View {
        HStack(content: {
            Text("A\(index + 1).")
                .font(.H4_bold)
            Spacer()
            categorySet
        })
        .frame(maxWidth: 136)
    }
    
    /// Category(categoryText와 뒷배경까지)
    private var categorySet: some View {
        category
            .font(.Body4_medium)
            .frame(width: 47, height: 23)
            .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(categoryColor))
    }
    
    /// question
    private var question: some View {
        Text(data.question)
            .font(.Body4_medium)
    }
    
    /// answer
    private var answer: some View {
        Text(data.answer)
            .font(.Body4_medium)
            .transition(.opacity)
            .animation(.easeInOut(duration: 1.0), value: isFlipped)
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
        case .tooth:
            Text("이빨")
        }
    }
    //TODO: - 귀에 대한 색 컬러셋 추가하고 바꾸기
    /// 카테고리 뒷 배경
    private var categoryColor: Color {
        switch data.category {
        case .ear:
            Color(red: 1, green: 0.93, blue: 0.32)
                .opacity(0.4)
        case .eye:
            Color.afterEye
        case .hair:
            Color.afterClaw
        case .claw:
            Color.afterEye
        case .tooth:
            Color.afterTeeth
        }
    }
}

//MARK: - Preview

struct TopTenQuestion_Previews: PreviewProvider {
    static var previews: some View {
        TopTenQuestion(data: QnaFaqData(category: .ear, question: "털이 왜 이렇게 빠지는 지 궁금해요 !!", answer: "여름철 체온조절로 인해 털빠짐 현상이 발생할 수 있습니다"), index: 0)
            .previewLayout(.sizeThatFits)
    }
}
