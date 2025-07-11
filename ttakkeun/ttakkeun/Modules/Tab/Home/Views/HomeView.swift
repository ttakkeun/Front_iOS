//
//  HomeView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @State var homeProfileViewModel: HomeProfileCardViewModel
    @StateObject var homeTodoViewModel: HomeTodoViewModel
    @StateObject var homeRecommendViewModel: HomeRecommendViewModel
    
    // MARK: - Init
    init(container: DIContainer) {
        self.homeProfileViewModel = .init(container: container)
        self._homeTodoViewModel = .init(wrappedValue: .init(container: container))
        self._homeRecommendViewModel = .init(wrappedValue: .init(container: container))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom, content: {
            VStack(alignment: .center, spacing: 14, content: {
                TopStatusBar()
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
                
                HomeProfileCard(viewModel: homeProfileViewModel)
                
                Spacer()
            })
        })
//        .task {
//            homeProfileViewModel.getSpecificProfile()
//            homeTodoViewModel.getTodoSchedule()
//            homeRecommendViewModel.getAIProduct()
//            homeRecommendViewModel.getUserProduct()
//        }
        .background(Color.mainPrimary)
//        .onDisappear {
//            homeProfileViewModel.profileData = nil
//            homeRecommendViewModel.aiProduct = nil
//            homeRecommendViewModel.userProduct = nil
//        }
    }
}

#Preview {
    HomeView(container: DIContainer())
}
