//
//  LoginViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/22/24.
//

import Foundation
import Moya
import CombineMoya
import Combine

@Observable
class LoginViewModel {
    // MARK: - StateProperty
    var isLoading: Bool = false
    
    // MARK: - UserInfo
    var userName: String {
        return UserDefaults.standard.string(forKey: AppStorageKey.userName) ?? "유저 이름 정보 없음"
    }
    var userEmail: String {
        return UserDefaults.standard.string(forKey: AppStorageKey.userEmail) ?? "유저 이메일 정보 없음"
    }
    
    // MARK: - Manager
    let appleLoginManager = AppleLoginManager()
    let kakaoLoginManager = KakaoLoginManager()
    
    // MARK: - Dependency
    let appFlowViewModel: AppFlowViewModel
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        container: DIContainer,
        appFlowViewModel: AppFlowViewModel
    ) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
        self.appleLoginManager.onAuthorizationCompleted = { [weak self] authorization, email, name in
            
            guard let self = self else { return }
            
            if let name = name, !name.isEmpty {
                UserDefaults.standard.setValue(name, forKey: AppStorageKey.userName)
            }
            
            if let email = email, !email.isEmpty {
                UserDefaults.standard.setValue(email, forKey: AppStorageKey.userEmail)
            }
            
            self.loginApple(signUpRequest: .init(identityToken: authorization, email: userEmail, name: userName))
        }
    }
    
    // MARK: - Common
    /// 회원 가입 페이지로 이동 -> 회원 정보 없을 시 작동한다.
    private func goToSignupPage(socialType: SocialLoginType, signUpData: SignUpData) {
        self.container.navigationRouter.push(to: .auth(.signUp(socialType: socialType, signup: signUpData)))
    }
    
    /// 키체인 값 저장
    /// - Parameter tokenResponse: 키체인에 필요한 서버 DTO 값
    private func saveKeychain(tokenResponse: TokenResponse?) {
        guard let tokenResponse = tokenResponse else { return }
        
        let userInfo = UserInfo(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
        let checkChain = KeyChainManager.standard.saveSession(userInfo, for: KeyChainManager.keyChainSession)
        
        #if DEBUG
        print("키체인 저장 성공 : \(checkChain)")
        print("저장된 키체인: \(String(describing: KeyChainManager.standard.loadSession(for: KeyChainManager.keyChainSession)))")
        #endif
    }
    
    /// 회원가입 필요 시, 회원가입 뷰로 넘어가는 함수
    /// - Parameters:
    ///   - socialType: 소셜 로그인 타입
    ///   - signUpData: 소셜 로그인 정보
    ///   - message: 서버로부터 받아온 메시지
    private func signUpFlow(socialType: SocialLoginType, signUpData: SignUpData, message: String) {
        self.goToSignupPage(socialType: socialType, signUpData: signUpData)
        print("로그인 실패: \(message)")
    }
    
    /// 회원 가입 데이터로 변환
    /// - Parameters:
    ///   - kakao: 카카오 데이터 변환
    ///   - apple: 애플 데이터 변환
    /// - Returns: 회원 가입 데이터 변환 값
    private func convertSignUpData(kakao: KakaoLoginRequest? = nil, apple: AppleLoginRequest? = nil) -> SignUpData {
        if let kakao = kakao {
            return SignUpData(token: kakao.accessToken, email: kakao.email, name: kakao.name)
        } else if let apple = apple {
            return SignUpData(token: apple.identityToken, email: apple.email, name: apple.name)
        }
    }
    
    /// API 성공 후 처리 액션
    /// - Parameters:
    ///   - tokenResponse: 성공 후 전달 받은 토큰 정보
    ///   - socicalLoginType: 소셜 로그인 타입
    private func successAction(tokenResponse: TokenResponse, socicalLoginType: SocialLoginType) {
        self.saveKeychain(tokenResponse: tokenResponse)
        UserDefaults.standard.setValue(socicalLoginType.rawValue, forKey: AppStorageKey.userLoginType)
        self.appFlowViewModel.onLoginSuccess(loginViewModel: self)
    }
    
    // MARK: - AppleLogin
    /// 뷰에서 작동하는 애플 로그인 버튼 기능
    public func appleLogin() {
        appleLoginManager.signWithApple()
    }
    
    /// 애플 로그인 서버 전달 함수
    /// - Parameter appleRequest: 애플 로그인 정보
    private func loginApple(appleRequest: AppleLoginRequest) {
        isLoading = true
        
        container.useCaseProvider.authUseCase.executeAppleLogin(appleLoginRequest: appleRequest)
            .validateResult(onFailureAction: {
                self.signUpFlow(socialType: .apple, signUpData: self.convertSignUpData(apple: appleRequest), message: "애플 로그인 실패")
            })
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { isLoading = false }
                
                switch completion {
                case .finished:
                    print("Apple Login Completed")
                case .failure(let failure):
                    print("Apple Login Failed: \(failure)")
                }
            }, receiveValue: { [weak self] tokenResponse in
                guard let self = self else { return }
                successAction(tokenResponse: tokenResponse, socicalLoginType: .apple)
            })
            .store(in: &cancellables)
    }

    // MARK: - KakaoLogin
    /// 뷰에서 실행하는 카카오 로그인 시도
    public func kakaoLogin() {
        kakaoLoginManager.fetchAccessToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let oauth):
                self.getKakaoUserInfo(accessToken: oauth)
            case .failure(let error):
                print("카카오 토큰 획득 실패: \(error)")
            }
        }
    }
    
    /// 카카오 토큰 조회 성공 시, 카카오 유저 정보 획득
    /// - Parameter accessToken: 획득한 카카오 토큰 값
    private func getKakaoUserInfo(accessToken: String) {
        kakaoLoginManager.getUserEmail(accessToken: accessToken) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let email):
                self.kakaoLoginManager.getUserName { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let nickname):
                        let request = KakaoLoginRequest(accessToken: accessToken, email: email, name: nickname)
                        self.loginKakao(kakaoRequest: request)
                    case .failure(let error):
                        print("카카오 닉네임 획득 실패: \(error)")
                    }
                }
            case .failure(let error):
                print("카카오 이메일 획득 실패: \(error)")
            }
        }
    }
    
    /// 카카오 서버 API
    /// - Parameter kakaoRequest: 카카오로부터 받은 값 전달
    private func loginKakao(kakaoRequest: KakaoLoginRequest) {
        isLoading = true
        
        container.useCaseProvider.authUseCase.executeKakaoLogin(kakaoLoginRequest: kakaoRequest)
            .validateResult(onFailureAction: {
                self.signUpFlow(socialType: .kakao, signUpData: self.convertSignUpData(kakao: kakaoRequest), message: "카카오 로그인 실패")
            })
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoading = false }
                
                switch completion {
                case .finished:
                    print("Kakao Login Completed")
                case .failure(let failure):
                    print("kakao Login Failed: \(failure)")
                }
            }, receiveValue: { [weak self] tokenResponse in
                guard let self = self else { return }
                successAction(tokenResponse: tokenResponse, socicalLoginType: .kakao)
            })
            .store(in: &cancellables)
    }
    
}
