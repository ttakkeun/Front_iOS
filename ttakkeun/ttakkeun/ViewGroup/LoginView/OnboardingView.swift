//
//  OnboardingView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/8/24.
//

import SwiftUI
import Lottie


/// 로그인 화면 전 온보딩 뷰, 유저 정보 조회
struct OnboardingView: View {
    
    @ObservedObject var viewModel: AppFlowViewModel
    
    var body: some View {
        ZStack() {
            RadialGradient(colors: [Color.onboarding_Color, .white], center: .center, startRadius: 0, endRadius: 260)
            
            
            LottieView(animation: .named("Onboarding"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
        }
        .onAppear { 
            Task {
                await viewModel.startAppFlow { isRegisted, error in
                    if let error = error {
                        viewModel.userExistence = false
                        print("온보딩 리프레시 에러 : \(error.localizedDescription)")
                    } else {
                        print("리프레쉬 성공")
                        viewModel.userExistence = true
                    }
                }
            }
        }
    }
}

struct OnboardingView_PreView: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: AppFlowViewModel())
    }
}
