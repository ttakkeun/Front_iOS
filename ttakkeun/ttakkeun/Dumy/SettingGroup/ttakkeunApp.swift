//
//  ttakkeunApp.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/7/24.
//

import SwiftUI

@main
struct ttakkeunApp: App {
    
    @StateObject var appFlowViewModel: AppFlowViewModel = AppFlowViewModel()
    @StateObject var petState: PetState = PetState()
    @StateObject var container: DIContainer = DIContainer()
    @StateObject var tabBarVisibility: TabBarVisibilityManager = TabBarVisibilityManager()
    
    var body: some Scene {
        WindowGroup {
            switch appFlowViewModel.appState {
            case .onBoarding:
                OnboardingView()
                    .environmentObject(appFlowViewModel)
            case .login:
                LoginView(viewModel: LoginViewModel(container: container))
                    .environmentObject(appFlowViewModel)
                    .environmentObject(container)
            case .profile:
                ProfileView(viewModel: ProfileCardViewModel(container: container))
                    .environmentObject(petState)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            case .TabView:
                TabView()
                    .environmentObject(petState)
                    .environmentObject(container)
                    .environmentObject(tabBarVisibility)
            }
        }
    }
}
