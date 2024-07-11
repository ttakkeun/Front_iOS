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
        self._viewModel = StateObject(wrappedValue: LoginViewModel())
    }
    
    var body: some View {
        contetsView
    }
    
    // MARK: - LogoView
    
    private var contetsView: some View {
        VStack(alignment: .center, content: {
            
            Spacer().frame(height: 200)
            
            topLogoContents
            
            Spacer().frame(height: 180)
            
            loginBtnGroup
            
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
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
                .foregroundStyle(Color.mainTextColor_Color)
            
        }
    }
    
    /// 상단 로고 텍스트 및 이미지
    private var topLogoTextImage: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Icon.petFriends.image
                .fixedSize()
            Text("따끈")
                .font(.santokki(type: .regular, size: 60))
                .foregroundStyle(Color.mainTextColor_Color)
                .frame(width: 116, height: 50)
        })
    }
    
    /// 로그인 버튼 그룹
    private var loginBtnGroup: some View {
        VStack(alignment: .center, spacing: 14, content: {
            Button(action: {
                Task {
                    await viewModel.kakaoLoginBtn()
                }
                
            }, label: {
                Icon.kakaoLogin.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 330, height: 44)
            })
            
            Button(action: {
                Task {
                    await viewModel.appleLoginBtn()
                }
            }, label: {
                Icon.appleLogin.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 330, height: 44)
            })
        })
    }
}

struct LoginView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
