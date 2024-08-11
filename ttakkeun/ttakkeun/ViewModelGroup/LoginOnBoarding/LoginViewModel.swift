//
//  LoginViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/10/24.
//

import Foundation
import Moya

/// 로그인 뷰 사용되는 뷰모델
@MainActor
class LoginViewModel: ObservableObject {
    
    let provider: MoyaProvider<UserLoginAPITarget>
    let keychain = KeyChainManager.standard
    let appleLoginManager =  AppleLoginManager()
    var userInfo = UserInfo()
    
    init(
        provider: MoyaProvider<UserLoginAPITarget> = APIManager.shared.testProvider(for: UserLoginAPITarget.self)
    ) {
        self.provider = provider
        self.appleLoginManager.onAuthorizationCompleted = { [weak self] authorizationCode in
            self?.sendUserIdentyCode(token: authorizationCode)
        }
    }
    
    // MARK: - ViewFunction
    
    
    //TODO: - 추후 마지막에 개발할 것!! 프리뷰 문제로 인함
    public func kakaoLoginBtn() async {
        print("카카오 로그인 버튼 액션")
    }
    
    public func appleLoginBtn() async {
        appleLoginManager.signWithApple()
    }
    
    // MARK: - LoginAPI
    
    /// 로그인 데이터 전송
    /// - Parameter token: 인가 코드
    private func sendUserIdentyCode(token: String) {
        provider.request(.appleLogin(token: token)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerInvalidToken(response: response)
            case .failure(let error):
                print("인가 코드 전송 네트워크 오류 : \(error)")
            }
        }
    }
    
    /// 애플 로그인 성공 시 받게 되는 Response 데이터
    /// - Parameter response: response 데이터
    private func handlerInvalidToken(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(LoginResponseData.self, from: response.data)
            self.userInfo = UserInfo(accessToken: decodedData.result.accessToken, refreshToken: decodedData.result.refreshToken)
            let saveData =  keychain.saveSession(self.userInfo, for: "userSession")
            print("키 체인 저장 완료 :\(saveData)")
        } catch {
            print("토큰 디코더 오류 : \(error)")
        }
    }
    
}
