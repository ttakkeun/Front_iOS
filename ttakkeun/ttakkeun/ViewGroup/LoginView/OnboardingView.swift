//
//  OnboardingView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/8/24.
//

import SwiftUI
import Lottie

//TODO: - viewModel API 연결 필요합니다.
struct OnboardingView: View {
    var body: some View {
        ZStack() {
            RadialGradient(colors: [Color.onboarding_Color, .white], center: .center, startRadius: 0, endRadius: 260)
            
            
            LottieView(animation: .named("Onboarding"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
        }
    }
}

#Preview {
    OnboardingView()
}
