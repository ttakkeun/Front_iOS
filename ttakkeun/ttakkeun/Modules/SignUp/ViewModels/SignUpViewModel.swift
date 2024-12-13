//
//  SignUpViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var agreements: [AgreementData] = AgreementDetailData.loadAgreements()
    @Published var selectedAgreement: AgreementData?
    @Published var tokenResponse: TokenResponse? = nil
    
    @Published var userEmail: String = ""
    @Published var userNickname: String = "" {
        didSet {
            if userNickname.count > 8 {
                userNickname = String(userNickname.prefix(8))
            }
        }
    }
    
    let container: DIContainer
    let appFlowViewModel: AppFlowViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
    }
    
    public func toggleCheck(for item: AgreementData) {
        if let index = agreements.firstIndex(where: { $0.id == item.id }) {
            agreements[index].isChecked.toggle()
        }
    }
    
    public func toggleAllAgreements() {
        let newValue = !isAllChecked
        for index in agreements.indices {
            agreements[index].isChecked = newValue
        }
    }
    
    var isAllChecked: Bool {
        agreements.allSatisfy { $0.isChecked }
    }
    
    var isAllMandatoryChecked: Bool {
        agreements.filter { $0.isMandatory }.allSatisfy { $0.isChecked }
    }
    
    
    private func saveKeyChain(responseData: TokenResponse?, socialType: SocialLoginType) {
        if let responseData = responseData {
            let userInfo = UserInfo(accessToken: responseData.accessToken, refreshToken: responseData.refreshToken)
            let success = KeyChainManager.standard.saveSession(userInfo, for: "ttakkeunUser")
            print("회원 가입 후 로그인 성공: \(success)")
        }
    }
    
    private func saveUserInfo(signUpRequest: SignUpRequest) {
        UserDefaults.standard.set(signUpRequest.name, forKey: "UserNickname")
        UserDefaults.standard.set(signUpRequest.email, forKey: "UserEmail")
    }
    
}

// MARK: - SignUp

extension SignUpViewModel {
    public func signUpApple(signUpRequet: SignUpRequest) {
        container.useCaseProvider.authUseCase.executeSignUpApple(signUpRequest: signUpRequet)
            .tryMap { responseData -> ResponseData<TokenResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Apple SignUp Finished")
                case .failure(let failure):
                    print("Apple SignUp Faield: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.tokenResponse = responseData.result
                saveKeyChain(responseData: tokenResponse, socialType: .apple)
                saveUserInfo(signUpRequest: signUpRequet)
                container.navigationRouter.pop()
                appFlowViewModel.onSignUpSuccess()
                
            })
            .store(in: &cancellables)
    }
    
    public func signUpKakao(signUpRequet: SignUpRequest) {
        container.useCaseProvider.authUseCase.executeSignUpkakaoLogin(signUpRequest: signUpRequet)
            .tryMap { responseData -> ResponseData<TokenResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("kakao SignUp Finished")
                case .failure(let failure):
                    print("kakao SignUp Faield: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.tokenResponse = responseData.result
                saveKeyChain(responseData: tokenResponse, socialType: .kakao)
                saveUserInfo(signUpRequest: signUpRequet)
                container.navigationRouter.pop()
                appFlowViewModel.onSignUpSuccess()
                
            })
            .store(in: &cancellables)
    }
}
