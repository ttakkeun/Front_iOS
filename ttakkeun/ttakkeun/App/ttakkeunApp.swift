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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appFlowViewModel: AppFlowViewModel = .init()
    @StateObject var container: DIContainer = .init()
    
    init() {
        KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            WriteTipsView(category: .part(.claw), container: DIContainer())
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
//                TtakeunTab()
//                    .environmentObject(container)
//                    .environmentObject(appFlowViewModel)
//            }
        }
    }
}
