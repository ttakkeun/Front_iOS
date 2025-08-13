//
//  QnAView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import SwiftUI

struct QnAView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var qnaSegmentValue: QnASegment = .faq
    @State var isFloatingShow: Bool = false
    
    // MARK: - Constants
    fileprivate enum QnAConstants {
        static let contentsVspacing: CGFloat = 28
        static let tabSpacing: CGFloat = 8
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(content: {
            qnaScreen
            /* floating 버튼 */
            if qnaSegmentValue == .tips {
                FloatingCircle(isShowFloating: $isFloatingShow)
            }
        })
        .background(Color.scheduleBg)
        .safeAreaInset(edge: .top, content: {
            topStatus
        })
    }
    
    /// 상단 상태바
    private var topStatus: some View {
        TopStatusBar()
            .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    /// 탭뷰 QnA 스크린
    private var qnaScreen: some View {
        VStack(alignment: .leading, spacing: QnAConstants.tabSpacing, content: {
            QnAHeader(selectedSegment: $qnaSegmentValue)
                .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
            
            TabView(selection: $qnaSegmentValue, content: {
                FAQView()
                    .tag(QnASegment.faq)
                
                TipsView(container: container)
                    .tag(QnASegment.tips)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
        })
        .background(Color.scheduleBg)
    }
}

#Preview {
    QnAView()
        .environmentObject(DIContainer())
}
