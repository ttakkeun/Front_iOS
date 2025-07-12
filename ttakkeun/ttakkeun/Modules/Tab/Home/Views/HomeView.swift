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
    
    // MARK: - Constants
    fileprivate enum HomeConstants {
        static let topVspacing: CGFloat = 14
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.homeProfileViewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom, content: {
            topContents
            HomeDragView(container: container, petType: .cat)
        })
        .background(Color.mainPrimary)
    }
    
    // MARK: - TopContents
    private var topContents: some View {
        VStack(alignment: .center, spacing: HomeConstants.topVspacing, content: {
            TopStatusBar()
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
            
            HomeProfileCard(viewModel: homeProfileViewModel)
            
            Spacer()
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
}

#Preview {
    HomeView(container: DIContainer())
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
