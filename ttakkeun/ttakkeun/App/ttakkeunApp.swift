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
            MyInquireDetailView(inquiryResponse: .init(contents: "이 사람 이상해요", email: "eui@com", inquiryType: "11", imageUrl: [
                "https://i.namu.wiki/i/cusLffdONLphUHKfYy-UclkoCER49OYM6SW96csASHewLpoQtigXVU8__1d_Nm97MuVoNHZ382GPm8gqim_gVI0e8aqzgNECEFNhTHNowe9ItibQynXg7q6NU78kDZGFD1Y0V5k9Oeql15OQo45Qjw.webp"
            ], created_at: "111"))
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
