//
//  LoginView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: LoginViewModel
    
    // MARK: - Constants
    fileprivate enum LoginConstants {
        static let contentsVspacing: CGFloat = 17
        static let logoVspacing: CGFloat = 5
        
        static let fontSize: CGFloat = 60
        static let logoBgWidth: CGFloat = 229
        static let logoBgHeight: CGFloat = 115
        static let logoOffset: CGFloat = -10
        static let logoTextSize: CGFloat = 14
        
        static let logoText: String = "따끈"
        static let logoSubText: String = "'따끈'하게 '닦은', AI 반려동물 스킨케어 서비스"
    }
    
    // MARK: - Init
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.viewModel = .init(container: container, appFlowViewModel: appFlowViewModel)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            VStack(alignment: .center) {
                Spacer()
                topContents
                Spacer()
                appleLoginButton
            }
            .safeAreaPadding(.bottom, UIConstants.safeBottom)
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
            }
        }
    }
    // MARK: - TopContents
    /// 상단 탑 컨텐츠
    private var topContents: some View {
        VStack(alignment: .center, spacing: LoginConstants.contentsVspacing, content: {
            logoContents
            
            Text(LoginConstants.logoSubText)
                .font(.suit(type: .medium, size: LoginConstants.logoTextSize))
                .foregroundStyle(Color.black)
        })
    }
    
    /// 로고 백그라운드 결합
    private var logoContents: some View {
        ZStack(alignment: .bottom, content: {
            Image(.logoBackground)
                .resizable()
                .frame(width: LoginConstants.logoBgWidth, height: LoginConstants.logoBgHeight)
            
            logoTextAndImage
                .offset(y: LoginConstants.logoOffset)
        })
    }
    
    /// 상단 로고 및 이미지
    private var logoTextAndImage: some View {
        VStack(alignment: .center, spacing: LoginConstants.logoVspacing, content: {
            Image(.logo)
                .fixedSize()
            Text(LoginConstants.logoText)
                .font(.santokki(type: .regular, size: LoginConstants.fontSize))
                .foregroundStyle(Color.black)
        })
    }
    
    // MARK: - BottomContents
    /// 애플 로그인 버튼
    private var appleLoginButton: some View {
        Button(action: {
            viewModel.appleLogin()
        }, label: {
            Image(.appleLogin)
                .fixedSize()
        })
    }
    
    private var kkakaoLoginButton: some View {
        Button(action: {
            viewModel.kakaoLogin()
        }, label: {
            Image(.kakaoButton)
                .fixedSize()
        })
    }
}
