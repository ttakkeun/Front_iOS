//
//  QnAView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/12/24.
//

import SwiftUI

struct QnAView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @Binding var qnaSegmentValue: QnASegment
    
    init(qnaSegmentValue: Binding<QnASegment>) {
        self._qnaSegmentValue = qnaSegmentValue
    }
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            TopStatusBar()
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
            
            QnAHeader(selectedSegment: $qnaSegmentValue)
                .frame(width: 353, alignment: .leading)
                .padding(.top, 12)
            
            changeSegmentView
        })
        .background(Color.scheduleBg)
    }
    
    @ViewBuilder
    private var changeSegmentView: some View {
        switch qnaSegmentValue {
        case .faq:
            FAQView()
        case .tips:
            TipsView(container: container)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        }
    }
}

struct QnAView_Preview: PreviewProvider {
    static var previews: some View {
        QnAView(qnaSegmentValue: .constant(.faq))
            .environmentObject(DIContainer())
            .environmentObject(AppFlowViewModel())
    }
}
