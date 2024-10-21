//
//  ContentView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        contetsView
    }
    
    // MARK: - LogoView
    
    private var contetsView: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            VStack(alignment: .center, content: {
                
                Spacer().frame(height: 200)
                
                topLogoContents
                
                Spacer().frame(height: 180)
                
                loginBtnGroup
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
                    .environmentObject(appFlowViewModel)
            }
        }
    }
    
    /// 상단 로고
    private var topLogoContents: some View {
        VStack(alignment: .center, spacing: 17) {
            ZStack(alignment: .bottom, content: {
                Icon.loginBackground.image
                    .resizable()
                    .frame(width: 229, height: 115)
                
                topLogoTextImage
                    .padding(.bottom, 20)
            })
            
            Text("'따끈'하게 '닦은', AI 반려동물 스킨케어 서비스")
                .font(.suit(type: .medium, size: 14))
                .foregroundStyle(Color.black)
            
        }
    }
    
    /// 상단 로고 텍스트 및 이미지
    private var topLogoTextImage: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Icon.petFriends.image
                .fixedSize()
            Text("따끈")
                .font(.santokki(type: .regular, size: 60))
                .foregroundStyle(Color.black)
                .frame(width: 116, height: 50)
        })
    }
    
    /// 로그인 버튼 그룹
    private var loginBtnGroup: some View {
            /* Apple 로그인 */
            Button(action: {
                Task {
                    await viewModel.appleLoginBtn()
                    appFlowViewModel.onLoginSuccess(loginViewModel: viewModel)
                }
            }, label: {
                Icon.appleLogin.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 330, height: 44)
            })
    }
}

struct LoginView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView(viewModel: LoginViewModel(container: DIContainer()))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
