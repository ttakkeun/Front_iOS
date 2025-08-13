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
    
    var isLogin: Bool = false
    var isLoading: Bool = false
    
    let appleLoginManager = AppleLoginManager()
    let kakaoLoginManager = KakaoLoginManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    let container: DIContainer
    let appFlowViewModel: AppFlowViewModel
    
    init(
        container: DIContainer,
        appFlowViewModel: AppFlowViewModel
    ) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
        self.appleLoginManager.onAuthorizationCompleted = { [weak self] authorization, email, name in
            
            guard let self = self else { return }
            
            if let name = name, !name.isEmpty {
                UserState.shared.setUserName(name)
            }
            
            
            if let email = email, !email.isEmpty {
                UserState.shared.setUserEmail(email)
            }
            
            self.loginApple(signUpRequest: SignUpRequest(identityToken: authorization, email: UserState.shared.getUserEmail(), name: UserState.shared.getUserName()))
        }
    }
    
    
    /// 회원 가입 페이지로 이동 -> 회원 정보 없을 시 작동한다.
    private func goToSignupPage(socialType: SocialLoginType, singUpRequest: SignUpRequest) {
        self.container.navigationRouter.push(to: .auth(.signUp(socialType: socialType, signUpRequest: singUpRequest)))
    }
    
    public func appleLogin() {
        appleLoginManager.signWithApple()
    }
    
    public func kakaoLogin() {
        kakaoLoginManager.fetchAccessToken { [weak self] result in
            switch result {
            case .success(let oauth):
                self?.kakaoLoginManager.getUserEmail(accessToken: oauth) { [weak self] result in
                    switch result {
                    case .success(let email):
                        self?.kakaoLoginManager.getUserName { [weak self] result in
                            switch result {
                            case .success(let nickname):
                                self?.loginKakao(signUpRequest: SignUpRequest(identityToken: oauth, email: email, name: nickname))
                            case .failure(let failure):
                                print("카카오 닉네임 받아오지 못했습니다. \(failure)")
                            }
                        }
                    case .failure(let failure):
                        print("카카오로부터 이메일을 받아오지 못했습니다. \(failure)")
                    }
                }
            case .failure(let failure):
                print("카카오로부터 토큰을 받아오지 못했습니다. \(failure)")
            }
        }
    }
    
    private func handleSignUpFlow(singUpRequest: SignUpRequest, message: String, socialType: SocialLoginType) {
        print("로그인 실패: \(message)")
        self.isLogin = false
        self.goToSignupPage(socialType: socialType, singUpRequest: singUpRequest)
    }
    
    private func saveKeychain(tokenResponse: TokenResponse?) {
        if let tokenResponse = tokenResponse {
            
            let userInfo = UserInfo(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
            
            let checkChain = KeyChainManager.standard.saveSession(userInfo, for: "ttakkeunUser")
            print("키체인 저장 성공 : \(checkChain)")
            print("저장된 키체인: \(String(describing: KeyChainManager.standard.loadSession(for: "ttakkeunUser")))")
        }
    }
}

extension LoginViewModel {
    
    // MARK: - SignApple
    
    public func loginApple(signUpRequest: SignUpRequest) {
        
        isLoading = true
        
        container.useCaseProvider.authUseCase.executeAppleLogin(signUpRequest: signUpRequest)
            .tryMap { responseData -> ResponseData<TokenResponse> in
                if !responseData.isSuccess {
                    self.handleSignUpFlow(singUpRequest: signUpRequest, message: responseData.message, socialType: .apple)
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("Apple LoginServer: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    print("Apple Login Completed")
                case .failure(let failure):
                    print("Apple Login Failed: \(failure)")
                    isLogin = false
                }
            },
                  receiveValue: { [weak self] tokenResponse in
                guard let self = self else { return }
                isLogin = true
                saveKeychain(tokenResponse: tokenResponse.result)
                appFlowViewModel.onLoginSuccess(loginViewModel: self)
            })
            .store(in: &cancellables)
    }
    
    public func loginKakao(signUpRequest: SignUpRequest) {
        isLoading = true
        
        container.useCaseProvider.authUseCase.executeKakaoLogin(signUpRequest: signUpRequest)
            .tryMap { responseData -> ResponseData<TokenResponse> in
                
                if !responseData.isSuccess {
                    self.handleSignUpFlow(singUpRequest: signUpRequest, message: responseData.message, socialType: .kakao)
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("Kakao LoginServer: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    print("Kakao Login Completed")
                case .failure(let failure):
                    print("kakao Login Failed: \(failure)")
                    isLogin = false
                }
            },
                  receiveValue: { [weak self] tokenResponse in
                guard let self = self else { return }
                isLogin = true
                saveKeychain(tokenResponse: tokenResponse.result)
                appFlowViewModel.onLoginSuccess(loginViewModel: self)
            })
            .store(in: &cancellables)
    }
}
