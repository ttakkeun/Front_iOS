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
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selectedTab {
                case .home:
                    VStack(spacing: 8, content: {
                        TopStatusBar()
                        Text("hello")
                        
                        Spacer()
                    })
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
}
