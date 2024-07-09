//
//  ContentView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: LoginViewModel())
    }
    
    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        VStack(alignment: .center, spacing: 17, content: {
            
            Spacer().frame(height: 200)
            
            topBacgroundLogo
            
            Text("'따끈'하게 '닦은', AI 반려동물 스킨케어 서비스")
                .font(.suit(type: .medium, size: 14))
                .foregroundStyle(Color.mainTextColor_Color)
            
            Spacer().frame(height: 180)
            
            loginBtnGroup
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
    }
    
    /// 상단 로고 합친 그룹
    private var topBacgroundLogo: some View {
        ZStack(alignment: .bottom, content: {
            Icon.loginBackground.image
                .fixedSize()
            
            mainLogo
                .padding(.bottom, 15)
        })
    }
    
    /// 로고 이미지와 앱 타이틀
    private var mainLogo: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Icon.petFriends.image
                .fixedSize()
            
            Text("따끈")
                .frame(height: 50)
                .font(.santokki(type: .regular, size: 60))
                .foregroundStyle(Color.mainTextColor_Color)
        })
        .frame(height: 154)
    }
    
    /// 로그인 버튼 그룹
    private var loginBtnGroup: some View {
        VStack(alignment: .center, spacing: 16, content: {
            Button(action: {
                viewModel.kakakLogin()
            }, label: {
                Icon.kakaoLogin.image
                    .fixedSize()
            })
            
            Button(action: {
                viewModel.appleLogin()
            }, label: {
                Icon.appleLogin.image
                    .resizable()
                    .frame(height: 50)
            })
        })
        .frame(width: 236, height: 116)
    }
}

struct LoginVIew_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
