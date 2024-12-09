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
    
    
    // MARK: - TabView CustomAlert
    
    @State private var selectedTab: TabCase = .home
    @State private var opacity = 0.0
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            ZStack(alignment: .bottom) {
                switch selectedTab {
                case .home:
                    HomeView(container: container)
                        .environmentObject(container)
                        .environmentObject(appFlowViewModel)
                case .diagnosis:
                    DiagnosticsView(container: container, showAlert: $showAlert, alertText: $alertText, aiCount: $aiCount, alertType: $alertType)
                        .environmentObject(container)
                        .environmentObject(appFlowViewModel)
                case .schedule:
                    Text("schedule")
                case .suggestion:
                    Text("suggestion")
                case .qna:
                    Text("qna")
                }
                
                CustomTab(selectedTab: $selectedTab)
                
                if showAlert {
                    CustomAlert(alertText: alertText,
                                aiCount: aiCount,
                                alertAction: AlertAction(showAlert: $showAlert, yes: { print("네 진행하겠습니다.") }),
                                alertType: alertType)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 0))
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    TabView()
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
