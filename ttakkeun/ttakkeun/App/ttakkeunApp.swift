//
//  ttakkeunApp.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import SwiftUI

@main
struct ttakkeunApp: App {
    
    @StateObject var appFlowViewModel: AppFlowViewModel = AppFlowViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch appFlowViewModel.appState {
            case .onBoarding:
                OnboardingView()
                    .environmentObject(appFlowViewModel)
            case .login:
                Text("로그인")
            case .profile:
                Text("프로파일")
            case .tabView:
                Text("탭뷰")
            }
        }
    }
    
}
