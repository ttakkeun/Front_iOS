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
    
    // MARK: - Constants
    fileprivate enum QnAConstants {
        static let contentsVspacing: CGFloat = 36
        static let tabSpacing: CGFloat = 16
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: QnAConstants.contentsVspacing, content: {
            TopStatusBar()
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
            
            qnaScreen
        })
        .background(Color.scheduleBg)
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    /// 탭뷰 QnA 스크린
    private var qnaScreen: some View {
        VStack(alignment: .leading, spacing: QnAConstants.tabSpacing, content: {
            QnAHeader(selectedSegment: $qnaSegmentValue)
            
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
    QnAView()
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
