//
//  ttakkeunApp.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct ttakkeunApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var container: DIContainer = .init()
    @State var appFlowViewModel: AppFlowViewModel = .init()
    
    init() {
        KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            switch appFlowViewModel.appState {
            case .onBoarding:
                OnboardingView()
                    .environment(appFlowViewModel)
            case .login:
                LoginView(container: container, appFlowViewModel: appFlowViewModel)
                    .environmentObject(container)
                    .environment(appFlowViewModel)
                    .onOpenURL(perform: { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    })
            case .profile:
                ProfileView(container: container)
                    .environmentObject(container)
                    .environment(appFlowViewModel)
            case .tabView:
                TtakeunTab()
                    .environmentObject(container)
                    .environment(appFlowViewModel)
            }
        }
    }
}
