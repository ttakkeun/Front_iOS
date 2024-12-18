//
//  HomeView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @StateObject var homeProfileViewModel: HomeProfileCardViewModel
    @StateObject var homeTodoViewModel: HomeTodoViewModel
    @StateObject var homeRecommendViewModel: HomeRecommendViewModel
    
    init(container: DIContainer) {
        self._homeProfileViewModel = .init(wrappedValue: .init(container: container))
        self._homeTodoViewModel = .init(wrappedValue: .init(container: container))
        self._homeRecommendViewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            VStack(alignment: .center, spacing: 14, content: {
                TopStatusBar(showDivider: false)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
                
                HomeProfileCard(viewModel: homeProfileViewModel)
                
                Spacer()
            })
            
                HomeDragView(homeProfileCardViewModel: homeProfileViewModel,
                             homeRecommendViewModel: homeRecommendViewModel,
                             homeTodoViewModel: homeTodoViewModel)
        })
        .task {
            homeProfileViewModel.getSpecificProfile()
            homeTodoViewModel.getTodoSchedule()
            homeRecommendViewModel.getAIProduct()
            homeRecommendViewModel.getUserProduct()
        }
        .background(Color.mainPrimary)
        .onDisappear {
            homeProfileViewModel.profileData = nil
            homeRecommendViewModel.aiProduct = nil
            homeRecommendViewModel.userProduct = nil
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        }
    }
    
    @ViewBuilder
    private var contents: some View {
        if homeTodoViewModel.todoIsLoading || homeRecommendViewModel.userRecommendIsLoading || homeRecommendViewModel.aiRecommendIsLoading {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    HomeView(container: DIContainer())
}
