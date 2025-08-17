//
//  AppFlowViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/22/24.
//

import Foundation

@Observable
class AppFlowViewModel {
    private let tokenProvider: TokenProvider = TokenProvider()
    
    var appState: AppState = .profile
    
    public func stateAppFlow(compleition: @escaping (Bool, Error?) -> Void) {
        tokenProvider.refreshToken { [weak self] accessToken, error in
            guard self != nil else { return }
            
            if let error = error {
                self?.appState = .login
                compleition(false, error)
                print("등록된 유저 정보 없음: \(error)")
                return
            }
            
            if accessToken != nil {
                // 유효한 토큰이 있을 경우 프로필 화면으로 이동
                self?.appState = .profile
                print("유저 존재하고 만료 안된 사용자")
                compleition(true, nil)
            } else {
                // 유효한 토큰이 없을 경우 로그인 화면으로 이동, 즉 리프레시 만료됨을 의미
                self?.appState = .login
                compleition(false, error)
            }
        }
    }
    
    /// 로그인 성공 후 호출
    public func onLoginSuccess(loginViewModel: LoginViewModel) {
        // 로그인 성공하면 프로필 화면 이동
        appState = .profile
    }
    
    /// 회원 가입 성공 후 호출
    public func onSignUpSuccess() {
        appState = .profile
    }
    
    // 프로필 선택 시 탭뷰 전환
    public func selectProfile() {
        appState = .tabView
    }
    
    public func logout() {
        appState = .login
    }
    
    public func deleteProfile() {
        appState = .profile
    }
}
