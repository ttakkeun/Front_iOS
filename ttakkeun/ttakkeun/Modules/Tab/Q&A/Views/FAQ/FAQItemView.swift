//
//  FAQItemView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

/// 질문 답변 리스트 아이템
struct FAQItemView: View {
    
    // MARK: - Property
    let data: FAQData
    let isExpanded: Bool
    let onToggle: () -> Void
    @Namespace private var animationNamespace
    
    // MARK: - Constants
    fileprivate enum FAQItemConstants {
        static let questionTitle: String = "Q."
        static let answerDetailData: String = "A."
        static let beforeBtnIcon: String = "chevron.down"
        static let afterBtnIcon: String = "chevron.up"
        static let nameEffect: String = "chevron"
        static let answerEffect: String = "answer"
        static let contentsVspacing: CGFloat = 8
        static let answerLeadingPadding: CGFloat = 20
        static let questionHspacing: CGFloat = 5
        static let lineSpacing: Double = 2
        static let animationDamping: Double = 0.7
        static let animationBlend: TimeInterval = 0.7
        static let animationResponse: Double = 0.3
        static let animationDuration: TimeInterval = 0.2
    }
    
    // MARK: - Init
    init(data: FAQData, isExpanded: Bool, onToggle: @escaping () -> Void) {
        self.data = data
        self.isExpanded = isExpanded
        self.onToggle = onToggle
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            withAnimation(.spring(
                response: FAQItemConstants.animationResponse,
                dampingFraction: FAQItemConstants.animationDamping,
                blendDuration: FAQItemConstants.animationBlend
            )) {
                onToggle()
            }
        }, label: {
            mainContetns
        })
    }
    
    private var mainContetns: some View {
        VStack(alignment: .leading, spacing: FAQItemConstants.contentsVspacing, content: {
            questTitle
            
            if isExpanded {
                answerDetailData
            }
        })
        .padding(.vertical, FAQItemConstants.answerLeadingPadding)
    }
    
    // MARK: - TopContents
    /// QnA 질문 타이틀
    private var questTitle: some View {
        HStack(alignment: .firstTextBaseline, spacing: FAQItemConstants.questionHspacing, content: {
            Group {
                Text(FAQItemConstants.questionTitle)
                Text(data.question)
                    .multilineTextAlignment(.leading)
            }
            .font(.Body3_bold)
            .foregroundStyle(Color.gray900)
            
            Spacer()
            
            Image(systemName: isExpanded ? FAQItemConstants.afterBtnIcon : FAQItemConstants.beforeBtnIcon)
                .matchedGeometryEffect(id: FAQItemConstants.nameEffect, in: animationNamespace)
                .foregroundStyle(Color.gray500)
        })
    }
    
    // MARK: - BottomContents
    /// QnA 질문 내용
    private var answerDetailData: some View {
        HStack(alignment: .firstTextBaseline, spacing: FAQItemConstants.questionHspacing, content: {
            Group {
                Text(FAQItemConstants.answerDetailData)
                Text(data.answer.cleanedAndLineBroken())
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(FAQItemConstants.lineSpacing)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.Body3_semibold)
            .foregroundStyle(Color.primarycolor700)
        })
        .padding(.leading, FAQItemConstants.answerLeadingPadding)
        .matchedGeometryEffect(id: FAQItemConstants.answerEffect, in: animationNamespace)
        .transition(.opacity .animation(.easeInOut(duration: FAQItemConstants.animationDuration)))
    }
}

struct FAQItemView_Preview: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
