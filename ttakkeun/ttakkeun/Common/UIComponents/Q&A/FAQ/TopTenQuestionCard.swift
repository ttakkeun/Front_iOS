//
//  TopTenQuestionCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

/// Top10 내용
struct TopTenQuestionCard: View {

    // MARK: - Property
    @State private var isFlipped: Bool = false
    @Binding var data: FAQData
    let index: Int
    
    // MARK: - Constant
    fileprivate enum TopTenQuestionPadding {
        static let titleWidth: CGFloat = 21
        static let titleHeight: CGFloat = 16
        static let contentsWidth: CGFloat = 136
        static let contentsHeight: CGFloat = 126
        static let contentsHorionPadding: CGFloat = 12
        static let contentsVerticalPadding: CGFloat = 15
        static let contentsVspacing: CGFloat = 21
        static let scrollContentsPadding: CGFloat = 6
        static let vertical: CGFloat = 3
        static let horizon: CGFloat = 18
        static let lineSpacing: Double = 1.5
        static let cornerRadius: CGFloat = 30
        static let contentsCornerRadius: CGFloat = 10
    }
    
    // MARK: - Init
    init(data: Binding<FAQData>, index: Int) {
        self._data = data
        self.index = index
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: TopTenQuestionPadding.contentsVspacing, content: {
            topTenTitle
            topTenContents
        })
        .frame(width: TopTenQuestionPadding.contentsWidth, height: TopTenQuestionPadding.contentsHeight)
        .padding(.horizontal, TopTenQuestionPadding.contentsHorionPadding)
        .padding(.vertical, TopTenQuestionPadding.contentsVspacing)
        .background(
            RoundedRectangle(cornerRadius: TopTenQuestionPadding.contentsCornerRadius)
                .fill(isFlipped ? Color.primarycolor100 : Color.white)
                .stroke(Color.gray200, style: .init())
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
    
    /// 10위 타이틀
    private var topTenTitle: some View {
        HStack(content: {
            Text("\(titleFirstWord())\(index + 1).")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            Spacer()
            
            Text(data.category.toKorean())
                .frame(width: TopTenQuestionPadding.titleWidth, height: TopTenQuestionPadding.titleHeight)
                .font(.Body4_medium)
                .padding(.vertical, TopTenQuestionPadding.vertical)
                .padding(.horizontal, TopTenQuestionPadding.horizon)
                .background(
                    RoundedRectangle(cornerRadius: TopTenQuestionPadding.cornerRadius)
                        .fill(data.category.toColor())
                )
        })
    }
    
    /// 10위 각 컨텐츠 내용
    private var topTenContents: some View {
        ScrollView(.vertical, content: {
            Text(dataString().cleanedAndLineBroken())
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .font(.Body4_medium)
                .lineSpacing(TopTenQuestionPadding.lineSpacing)
        })
        .contentMargins(.horizontal, TopTenQuestionPadding.scrollContentsPadding)
    }
}

extension TopTenQuestionCard {
    
    func titleFirstWord() -> String {
        if isFlipped {
            return "A"
        } else {
            return "Q"
        }
    }
    
    func dataString() -> String {
        if isFlipped {
            return data.answer
        } else {
            return data.question
        }
    }
}

struct TopTenQuestionCard_Preview: PreviewProvider {
    static var previews: some View {
        TopTenQuestionCard(data: .constant(FAQData(category: .ear, question: "털이 왜 이렇게 빠지 는지 궁금해요!!", answer: "혈관이 지나가는 부분인 '퀵(quick)'을 피해서 깎아야 합니다. 퀵을 다치게 하면 출혈이 발생할 수 있으므로, 밝은 색 발톱의 경우 퀵을 쉽게 식별할 수 있습니다.")), index: 1)
    }
}
