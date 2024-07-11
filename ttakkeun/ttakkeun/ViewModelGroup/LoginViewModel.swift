//
//  LoginViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/10/24.
//

import Foundation
import Moya

@MainActor
class LoginViewModel: ObservableObject {
    
    let provider: MoyaProvider<AuthAPITarget>
    let keychain = KeyChainManager.standard
    let appleLoginManager =  AppleLoginManager()
    var userInfo = UserInfo()
    
    init(
        provider: MoyaProvider<AuthAPITarget> = APIManager.shared.testProvider(for: AuthAPITarget.self)
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
        provider.request(.refreshToken(currentToken: token)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerInvalidToken(response: response)
            case .failure(let error):
                print("인가 코드 전송 네트워크 오류 : \(error)")
            }
        }
    }
    
    private func handlerInvalidToken(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(LoginResponseData.self, from: response.data)
            self.userInfo = UserInfo(accessToken: decodedData.accessToken, refreshToken: decodedData.refreshToken)
            let saveData =  keychain.saveSession(self.userInfo, for: "userSession")
            print("키 체인 저장 완료 :\(saveData)")
        } catch {
            print("토큰 디코더 오류 : \(error)")
        }
    }
    
}
