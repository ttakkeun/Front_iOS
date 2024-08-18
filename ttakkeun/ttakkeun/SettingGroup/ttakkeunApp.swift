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
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @StateObject var petState: PetState = PetState()
    @StateObject var container: DIContainer = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            //            if appFlowViewModel.userExistence || loginViewModel.isLogin {
            //                ProfileView()
            //                    .environmentObject(petState)
            //            } else {
            //                LoginView(viewModel: loginViewModel)
            //            }
            //        }
            FloatingWriteBtn()
        }
    }
}
