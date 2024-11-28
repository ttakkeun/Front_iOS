//
//  TopTenQuestionCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct TopTenQuestionCard: View {
    
    @State private var isFlipped: Bool = false
    
    @Binding var data: FAQData
    let index: Int
    
    init(data: Binding<FAQData>, index: Int) {
        self._data = data
        self.index = index
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21, content: {
            topTenTitle
            
            topTenContents
            
            Spacer()
        })
        .frame(width: 136, height: 126)
        .padding(.vertical, 15)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isFlipped ? Color.primarycolor100 : Color.white)
                .stroke(Color.gray200, lineWidth: 1)
                .rotation3DEffect(.degrees(isFlipped ? -180 : 0),
                                  axis: (x: 0, y: 1, z: 0),
                                  perspective: 0.1
                                 )
        )
        .animation(.default, value: isFlipped)
        .onTapGesture {
            isFlipped.toggle()
        }
    }
    
    private var topTenTitle: some View {
        HStack(content: {
            Text("\(titleFirstWord())\(index + 1).")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            Spacer()
            
            Text(data.category.toKorean())
                .frame(width: 21, height: 16)
                .font(.Body4_medium)
                .padding(.vertical, 3.5)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(data.category.toColor())
                )
        })
    }
    
    private var topTenContents: some View {
        Text(dataString().split(separator: "").joined(separator: "\u{200B}"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .font(.Body4_medium)
            .lineSpacing(1.5)
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
        TopTenQuestionCard(data: .constant(FAQData(category: .ear, question: "털이 왜 이렇게 빠지 는지 궁금해요!!", answer: "여름철 체온조절로 인해 털빠짐 현상이 발생할 수 있습니다.")), index: 1)
    }
}
