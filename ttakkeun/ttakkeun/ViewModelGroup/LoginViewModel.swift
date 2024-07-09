//
//  LoginViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import Moya

@MainActor
class LoginViewModel: ObservableObject {
    
    private var kakaoLoginManager: KakaoLoginManager
    private var appleLoginManager: AppleLoginManager
    
    private var provider: MoyaProvider<LoginAPITarget>
    
    init(
        kakaoLoginManager: KakaoLoginManager = KakaoLoginManager(),
        appleLoginManager: AppleLoginManager = AppleLoginManager(),
        provider: MoyaProvider<LoginAPITarget> = APIManager.shared.testProvider(for: LoginAPITarget.self)
    ) {
        self.kakaoLoginManager = kakaoLoginManager
        self.appleLoginManager = appleLoginManager
        self.provider = provider
    }
    
    // MARK: - LoginButtonFunction
    
    /// 카카오 로그인 기능
    public func loginKakao() {
        self.kakaoLoginManager.login { [weak self] result in
            switch result {
            case .success(let oauthToken):
                print("인가 코드 : \(oauthToken.accessToken)")
                self?.sendLoginRequest(token: oauthToken.accessToken)
            case .failure(let error):
                print("카카오 로그인 실패: \(error)")
            }
        }
    }
    
    /// 애플 로그인 기능
    public func appLogin() {
        self.appleLoginManager.signWithApple()
    }
    
    
    // MARK: - LoginAPIFunction
    
    /// 카카오 로그인 API 함수
    /// - Parameter token:  인가코드 전달
    private func sendLoginRequest(token: String) {
        provider.request(.sendIdentiCode(token: token)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerLoginRequest(response: response)
            case .failure(let error):
                print("로그인 네트워크 오류: \(error)")
            }
        }
    }
    
    /// 카카오 로그인 핸들러
    /// - Parameter response: 성공 시 받게 되는 반응값
    private func handlerLoginRequest(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(LoginResponseData.self, from: response.data)
            print(decodedData)
        } catch {
            print("로그인 리스폰스 디코드 오류: \(error)")
        }
    }
    
    
}
