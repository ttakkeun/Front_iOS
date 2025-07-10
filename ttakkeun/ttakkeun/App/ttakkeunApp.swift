//
//  ttakkeunApp.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI
import KakaoSDKCommon

@main
struct ttakkeunApp: App {
    
    @StateObject var appFlowViewModel: AppFlowViewModel = .init()
    @StateObject var container: DIContainer = .init()
    
    init() {
        KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            MakeProfileView(container: DIContainer())
                .environmentObject(DIContainer())
//            switch appFlowViewModel.appState {
//            case .onBoarding:
//                OnboardingView()
//                    .environmentObject(appFlowViewModel)
//            case .login:
//                LoginView(viewModel: LoginViewModel(container: container, appFlowViewModel: appFlowViewModel))
//                    .environmentObject(container)
//                    .environmentObject(appFlowViewModel)
//            case .profile:
//                ProfileView(container: container)
//                    .environmentObject(container)
//                    .environmentObject(appFlowViewModel)
//            case .tabView:
//                TabView()
//                    .environmentObject(container)
//                    .environmentObject(appFlowViewModel)
//            }
        }
    }
}
