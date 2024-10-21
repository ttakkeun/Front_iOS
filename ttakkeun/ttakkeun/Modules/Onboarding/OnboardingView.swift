//
//  OnboardingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
    var body: some View {
        ZStack() {
            RadialGradient(colors: [Color.onBoarding, .white], center: .center, startRadius: 0, endRadius: 260)
            
            
            LottieView(animation: .named("Onboarding"))
                .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
        }
    }
}

#Preview {
    OnboardingView()
}
