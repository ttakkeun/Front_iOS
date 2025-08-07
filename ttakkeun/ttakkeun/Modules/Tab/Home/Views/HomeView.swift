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
    @State var homeProfileViewModel: HomeProfileCardViewModel
    
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
        .safeAreaInset(edge: .top, content: {
            topStatus
        })
    }
    
    // MARK: - TopContents
    private var topStatus: some View {
        TopStatusBar()
            .environmentObject(container)
    }
    private var topContents: some View {
        VStack(alignment: .center, spacing: .zero, content: {
            HomeProfileCard(viewModel: homeProfileViewModel)
            Spacer()
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
}

#Preview {
    HomeView(container: DIContainer())
        .environmentObject(DIContainer())
}
