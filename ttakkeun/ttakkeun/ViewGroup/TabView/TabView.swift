//
//  TabView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import SwiftUI

/// 따끈앱의 모든 탭에 연결된 뷰를 담당하는 탭뷰
struct TabView: View {
    
    @EnvironmentObject var petState: PetState
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: TabCase = .home
    @State private var opacity = 0.0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            
                switch selectedTab {
                case .home:
                    HomeView()
                        .background(Color.primaryColor_Main)
                        .environmentObject(petState)
                        .tag(TabCase.home)
                case .diagnosis:
                    DiagnosisView(petId: petState.petId)
                        .tag(TabCase.diagnosis)
                case .schedule:
                    ScheduleView()
                        .tag(TabCase.schedule)
                case .suggestion:
                    SuggestionView()
                        .tag(TabCase.suggestion)
                case .qna:
                    QnaView()
                        .tag(TabCase.qna)
                }
            
            CustomTab(selectedTab: $selectedTab)
        })
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.75)) {
                self.opacity = 1.0
            }
        }
    }
}

#Preview {
    TabView()
        .environmentObject(PetState(petName: "유애", petId: 1))
}
