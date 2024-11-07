//
//  LoginView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

struct LoginView: View {
    
    let apple = AppleLoginManager()
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination, root: {
            VStack(alignment: .center, content: {
                Spacer().frame(height: 200)
                
                topLogoContents
                
                Spacer().frame(height: 180)
                
                Button(action: {
                    apple.signWithApple()
                }, label: {
                    Icon.appleLogin.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 330, height: 44)
                })
            })
        })
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
}

struct LoginView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            LoginView()
                .environmentObject(DIContainer())
                .environmentObject(AppFlowViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
