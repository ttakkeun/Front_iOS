//
//  SignUpViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import Foundation
import Combine

@Observable
class SignUpViewModel: ObservableObject {
    // MARK: - StateProperty
    /// 전부 체크 되었는지 확인
    var isAllChecked: Bool {
        agreements.allSatisfy { $0.isChecked }
    }
    
    /// 필스 요건 체크 했는지 확인
    var isAllMandatoryChecked: Bool {
        agreements.filter { $0.isMandatory }.allSatisfy { $0.isChecked }
    }
    
    // MARK: - Property
    /// 동의 항목 상태
    var agreements: [AgreementData] = AgreementDetailData.loadAgreements()
    /// 동의 항목 체크 후 시트 뷰
    var selectedAgreement: AgreementData?
    
    /// 유저 이메일 값
    var userEmail: String = ""
    /// 유저 닉네임 값
    var userNickname: String = "" {
        didSet {
            if userNickname.count > 8 {
                userNickname = String(userNickname.prefix(8))
            }
        }
    }
    // MARK: - Dependency
    let container: DIContainer
    let appFlowViewModel: AppFlowViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
    }
    
    // MARK: - Common
    /// 선택한 항목의 토클 액션
    /// - Parameter item: 무엇을 선택했는지 파악하기
    public func toggleCheck(for item: AgreementData) {
        if let index = agreements.firstIndex(where: { $0.id == item.id }) {
            agreements[index].isChecked.toggle()
        }
    }
    
    /// 전체 동의 액션
    public func toggleAllAgreements() {
        let newValue = !isAllChecked
        for index in agreements.indices {
            agreements[index].isChecked = newValue
        }
    }
    
    /// 전달 Request 변환
    /// - Parameters:
    ///   - data: 회원가입 뷰 사용 데이터
    ///   - type: 회원가입 소셜 타입
    /// - Returns: 카카오 또는 애플 데이터 반환
    public func convertRequest(_ data: SignUpData, type: SocialLoginType) -> Any {
        switch type {
        case .apple:
            return AppleLoginRequest(identityToken: data.token, email: data.email, name: userNickname)
        case .kakao:
            return KakaoLoginRequest(accessToken: data.token, email: data.email, name: userEmail)
        }
    }
    // MARK: - Keychain
    
    /// API 호출 후 키체인 값 저장
    /// - Parameters:
    ///   - responseData: 서버로부터 전달 받은 키체인
    ///   - socialType: 소셜 로그인 타입
    private func saveKeyChain(responseData: TokenResponse?, socialType: SocialLoginType) {
        if let responseData = responseData {
            let userInfo = UserInfo(accessToken: responseData.accessToken, refreshToken: responseData.refreshToken)
            let success = KeyChainManager.standard.saveSession(userInfo, for: KeyChainManager.keyChainSession)
            
            #if DEBUG
            print("회원 가입 후 로그인 성공: \(success)")
            #endif
        }
    }
    
    /// 유저 정보 디폴트 값 저장
    /// - Parameter signUpdata: 회원가입 시 데이터
    private func saveUserInfo(email: String, _ loginType: SocialLoginType) {
        UserDefaults.standard.set(self.userNickname, forKey: AppStorageKey.userNickname)
        UserDefaults.standard.set(email, forKey: AppStorageKey.userEmail)
        UserDefaults.standard.setValue(loginType.rawValue, forKey: AppStorageKey.userLoginType)
    }
    
    // MARK: - Apple Signup
    // FIXME: - 팅김 현상 발생 부분
    public func signUpApple(apple: AppleLoginRequest) {
        container.useCaseProvider.authUseCase.executeSignUpApple(appleLoginRequest: apple)
            .validateResult()
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
                saveKeyChain(responseData: responseData, socialType: .apple)
                saveUserInfo(email: apple.email, .apple)
                container.navigationRouter.pop()
                appFlowViewModel.onSignUpSuccess()
            })
            .store(in: &cancellables)
    }
    // MARK: - Kakao Signup
    public func signUpKakao(kakao: KakaoLoginRequest) {
        container.useCaseProvider.authUseCase.executeSignUpkakaoLogin(kakaoLoginRequest: kakao)
            .validateResult()
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
                saveKeyChain(responseData: responseData, socialType: .kakao)
                saveUserInfo(email: kakao.email, .kakao)
                container.navigationRouter.pop()
                appFlowViewModel.onSignUpSuccess()
                
            })
            .store(in: &cancellables)
    }
}
