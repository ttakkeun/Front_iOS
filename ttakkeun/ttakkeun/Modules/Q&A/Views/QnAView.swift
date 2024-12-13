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
        ZStack {
            VStack(alignment: .center, spacing: 0, content: {
                TopStatusBar()
                
                QnAHeader(selectedSegment: $qnaSegmentValue)
                    .frame(width: 353, alignment: .leading)
                    .padding(.top, 12)
                
                changeSegmentView
            })
            .background(Color.scheduleBg)
        }
        .navigationDestination(for: NavigationDestination.self) { detination in
            NavigationRoutingView(destination: detination)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        }
    }
    
    @ViewBuilder
    private var changeSegmentView: some View {
        switch qnaSegmentValue {
        case .faq:
            FAQView()
        case .tips:
            TipsView(container: container)
                .environmentObject(container)
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
