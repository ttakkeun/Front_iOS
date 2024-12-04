//
//  OnboardingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
    
    @EnvironmentObject var viewModel: AppFlowViewModel
    
    var body: some View {
        ZStack() {
            RadialGradient(colors: [Color.onBoarding, .white], center: .center, startRadius: 0, endRadius: 260)
            
            LottieView(animation: .named("Onboarding"))
                .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                .animationDidFinish { completed in
                    if completed {
                        viewModel.stateAppFlow { success, error in
                            if let error = error {
                                print("최초 사용자 혹은 등록된 유저 아님: \(error)")
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
            .environmentObject(AppFlowViewModel())
    }
}
