//
//  TabView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import SwiftUI

struct TabView: View {
    
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
                    Text("diag")
                case .schedule:
                    Text("schedule")
                case .suggestion:
                    Text("suggestion")
                case .qna:
                    Text("qna")
                }
                
                CustomTab(selectedTab: $selectedTab)
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
