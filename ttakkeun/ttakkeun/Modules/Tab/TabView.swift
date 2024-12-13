//
//  TabView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import SwiftUI

struct TabView: View {
    
    // MARK: - CustomAlert Property
    @State private var showAlert: Bool = false
    @State private var alertText: Text = Text("")
    @State private var aiCount: Int = 0
    @State private var alertType: AlertType = .aiAlert
    @State private var actionYes: () -> Void = {}
    
    // MARK: - FloatingButton
    @State private var isShowFloating: Bool = false
    @State private var qnaSegmentValue: QnASegment = .faq
    
    // MARK: - TabView Property
    
    @State private var selectedTab: TabCase = .home
    @State private var opacity = 0.0
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            Group {
                ZStack(alignment: .bottom) {
                    switch selectedTab {
                    case .home:
                        HomeView(container: container)
                    case .diagnosis:
                        DiagnosticsView(container: container, showAlert: $showAlert, alertText: $alertText, aiCount: $aiCount, alertType: $alertType, actionYes: $actionYes)
                    case .schedule:
                        Text("schedule")
                    case .suggestion:
                        RecommendView(container: container)
                    case .qna:
                        QnAView(qnaSegmentValue: $qnaSegmentValue)
                    }
                    
                    if qnaSegmentValue == .tips {
                        FloatingCircle(isShowFloating: $isShowFloating)
                            .zIndex(1)
                    }
                    
                    CustomTab(selectedTab: $selectedTab)
                    
                    if showAlert {
                        CustomAlert(alertText: alertText,
                                    aiCount: aiCount,
                                    alertAction: AlertAction(showAlert: $showAlert, yes: { actionYes() }),
                                    alertType: alertType)
                    }
                }
                .safeAreaPadding(EdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0))
                .ignoresSafeArea(.all).opacity(opacity)
                .task {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        self.opacity = 1.0
                    }
                }
            }
            .environmentObject(container)
            .environmentObject(appFlowViewModel)
            
        }
    }
}

#Preview {
    TabView()
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
