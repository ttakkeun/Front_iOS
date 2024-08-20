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
    
    @EnvironmentObject var viewModel: AppFlowViewModel
    
    var body: some View {
        ZStack() {
            RadialGradient(colors: [Color.onboarding_Color, .white], center: .center, startRadius: 0, endRadius: 260)
            
            
            LottieView(animation: .named("Onboarding"))
                .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                .animationDidFinish {completed in
                    if completed {
                        viewModel.startAppFlow { success, error in
                            if let error = error {
                                print("최초 사용자 입니다.: \(error)")
                            }
                        }
                    }
                }
        }
    }
}

struct OnboardingView_PreView: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
