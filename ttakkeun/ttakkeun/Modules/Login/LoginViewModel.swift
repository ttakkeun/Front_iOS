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

class LoginViewModel: ObservableObject {
    
    @Published var isLogin: Bool = false
    @Published var isLoading: Bool = false
    
    let appleLoginManager = AppleLoginManager()
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
            self?.loginApple(signUpRequest: SignUpRequest(identityToken: authorization, email: email ?? "", name: name))
        }
    }
    
    
    /// 회원 가입 페이지로 이동 -> 회원 정보 없을 시 작동한다.
    private func goToSignupPage(singUpRequest: SignUpRequest) {
        self.container.navigationRouter.push(to: .signUp(singUpRequest: singUpRequest))
    }
    
    public func appleLogin() {
        appleLoginManager.signWithApple()
    }
}

extension LoginViewModel {
    
    // MARK: - SignApple
    
    public func loginApple(signUpRequest: SignUpRequest) {
        isLoading = true
        
        container.useCaseProvider.authUseCase.executeAppleLogin(signUpRequest: signUpRequest)
            .tryMap { responseData -> ResponseData<TokenResponse> in
                if !responseData.isSuccess {
                    self.handleSignUpFlow(singUpRequest: signUpRequest, message: responseData.message)
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("LoginServer: \(responseData)")
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
    
    private func handleSignUpFlow(singUpRequest: SignUpRequest, message: String) {
        print("로그인 실패: \(message)")
        self.isLogin = false
        self.goToSignupPage(singUpRequest: singUpRequest)
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
