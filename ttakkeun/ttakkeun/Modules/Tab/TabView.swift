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
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selectedTab {
                case .home:
                    HomeView(container: container)
                case .diagnosis:
                    Text("diag")
                case .schedule:
                    Text("schedule")
                case .suggestion:
                    Text("suggestion")
                case .qna:
                    Text("qna")
                }
                
                Spacer()
                
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
}
