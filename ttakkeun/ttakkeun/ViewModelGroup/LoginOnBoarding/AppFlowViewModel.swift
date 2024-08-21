//
//  OnboardingViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import Foundation
import Moya

/// 앱 유저 정보 체크 뷰모델
@MainActor
class AppFlowViewModel: ObservableObject {
    private let tokenProvider: TokenProvider = TokenProvider()
    
    @Published var appState: AppState = .onBoarding
    @Published var userExistence: Bool = false
    
    /// 리프레시 통한 유저 정보 체크
    /// - Parameter completion: 유저 정보 채크 성공 여부
    public func startAppFlow(completion: @escaping (Bool, Error?) -> Void) {
        tokenProvider.refreshToken { [weak self] accessToken, error in
            guard self != nil else { return }
            
            if let error = error {
                // 로그인 화면으로 이동
                self?.appState = .login
                completion(false, error)
                print("등록된 유저 정보 없음: \(error)")
                return
            }
            
            if accessToken != nil {
                // 유효한 토큰이 있을 경우 프로필 화면으로 이동
                self?.userExistence = true
                self?.appState = .profile
                print("유저 존재하고 만료안된 사용자 -> 프로필 뷰 이동")
                completion(true, nil)
            } else {
                // 유효한 토큰이 없을 경우 로그인 화면으로 이동, 즉 리프레시 만료됨을 의미
                self?.appState = .login
                completion(false, nil)
            }
        }
    }
    
    /// 로그인 성공 후 호출
    public func onLoginSuccess(loginViewModel: LoginViewModel) {
        if loginViewModel.isLogin {
            // 로그인 성공하면 프로필 화면 이동
            appState = .profile
        }
    }
    
    /// 회원 가입 성공 후 호출
    public func onSignUpSuccess() {
        appState = .profile
    }
    
    // 프로필 선택 시 탭뷰 전환
    public func selectProfile() {
        appState = .TabView
    }
}
