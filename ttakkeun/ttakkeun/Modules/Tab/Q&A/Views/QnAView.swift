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
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State var qnaSegmentValue: QnASegment = .faq
    @Binding var isFloatingShow: Bool
    
    // MARK: - Constants
    fileprivate enum QnAConstants {
        static let contentsVspacing: CGFloat = 28
        static let tabSpacing: CGFloat = 8
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(content: {
            VStack(alignment: .leading, spacing: QnAConstants.contentsVspacing, content: {
                topStatus
                qnaScreen
            })
            .background(Color.scheduleBg)
            
            /* floating 버튼 */
            if qnaSegmentValue == .tips {
                FloatingCircle(isShowFloating: $isFloatingShow)
                    .environmentObject(container)
            }
        })
    }
    
    /// 상단 상태바
    private var topStatus: some View {
        TopStatusBar()
            .environmentObject(container)
            .environmentObject(appFlowViewModel)
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
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
        })
        .background(Color.scheduleBg)
    }
}

#Preview {
    @Previewable @State var isShowFloating: Bool = false
    
    QnAView(isFloatingShow: $isShowFloating)
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
