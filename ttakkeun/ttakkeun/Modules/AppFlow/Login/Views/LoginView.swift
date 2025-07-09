//
//  LoginView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            VStack(alignment: .center) {
                
                Spacer()
                
                topLogoContents
                
                Spacer().frame(height: 200)
                
                loginButtons
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            }
        }
    }
    
    private var topLogoContents: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ZStack(alignment: .bottom, content: {
                Icon.logoBackground.image
                    .resizable()
                    .frame(width: 229, height: 115)
                
                logoTextAndImage
                    .padding(.bottom, 20)
            })
            
            Text("'따끈'하게 '닦은', AI 반려동물 스킨케어 서비스")
                .font(.Body3_medium)
                .foregroundStyle(Color.black)
        })
    }
    
    private var logoTextAndImage: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Icon.logo.image
                .fixedSize()
            Text("따끈")
                .font(.santokki(type: .regular, size: 60))
                .foregroundStyle(Color.black)
                .frame(width: 116, height: 50)
        })
    }
    
    private var loginButtons: some View {
        VStack(alignment: .center, spacing: 20, content: {
            Button(action: {
                viewModel.appleLogin()
            }, label: {
                Icon.appleLogin.image
                    .fixedSize()
            })
            
            Button(action: {
                viewModel.kakaoLogin()
            }, label: {
                Icon.kakaoLogin.image
                    .fixedSize()
            })
        })
    }
}

struct LoginView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView(viewModel: LoginViewModel(container: DIContainer(), appFlowViewModel: AppFlowViewModel()))
                .environmentObject(DIContainer())
                .environmentObject(AppFlowViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
