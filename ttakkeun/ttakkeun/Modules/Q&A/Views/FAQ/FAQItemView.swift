//
//  FAQItemView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct FAQItemView: View {
    
    let question: String
    let answer: String
    let isExpanded: Bool
    let onToggle: () -> Void
    @Namespace private var animationNamespace
    
    init(question: String, answer: String, isExpanded: Bool, onToggle: @escaping () -> Void) {
        self.question = question
        self.answer = answer
        self.isExpanded = isExpanded
        self.onToggle = onToggle
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                onToggle()
            }
        }, label: {
            VStack(alignment: .leading, spacing: 10, content: {
                questionList
                
                if isExpanded {
                    answerList
                        .padding(.leading, 20)
                        .matchedGeometryEffect(id: "answer", in: animationNamespace)
                        .transition(.opacity .animation(.easeInOut(duration: 0.2)))
                }
            })
            .padding(.vertical, 20)
            .padding(.horizontal, 25)
            .background(Color.clear)
            .overlay(alignment: .bottom, content: {
                makeRectangle()
            })
            .overlay(alignment: .top, content: {
                makeRectangle()
            })
        })
    }
    
    private var questionList: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5, content: {
            Group {
                Text("Q.")
                
                Text(question)
                    .multilineTextAlignment(.leading)
            }
            .font(.Body3_bold)
            .foregroundStyle(Color.gray900)
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                .matchedGeometryEffect(id: "chevron", in: animationNamespace)
                .foregroundStyle(Color.gray500)
        })
    }

    private var answerList: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5, content: {
            Group {
                Text("A.")
                
                Text(answer.split(separator: "").joined(separator: "\u{200B}"))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                    .frame(maxWidth: 300, alignment: .leading)
            }
            .font(.Body3_semibold)
            .foregroundStyle(Color.primarycolor700)
        })
    }
    
    func makeRectangle() -> some View {
        Rectangle()
            .fill(Color.listDivde)
            .frame(height: 1)
    }
}

struct FAQItemView_Preview: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
