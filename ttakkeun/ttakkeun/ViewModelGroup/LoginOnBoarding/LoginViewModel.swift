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
    
    /* 등록된 유저이면 프로필 화면 전환, 등록된 유저 아니면 회원 가입 화면 전환*/
    @Published var isLogin: Bool = false
    
    let provider: MoyaProvider<UserLoginAPITarget>
    let keychain = KeyChainManager.standard
    let appleLoginManager =  AppleLoginManager()
    
    var userInfo = UserInfo()
    private var container: DIContainer
    
    init(
        provider: MoyaProvider<UserLoginAPITarget> = APIManager.shared.createProvider(for: UserLoginAPITarget.self),
        container: DIContainer
    ) {
        self.provider = provider
        self.container = container
        self.appleLoginManager.onAuthorizationCompleted = { [weak self] authorizationCode, email, name in
            self?.sendUserIdentyCode(signUp: SignUpData(token: authorizationCode, email: email ?? "", name: name))
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
    private func sendUserIdentyCode(signUp: SignUpData) {
        provider.request(.appleLogin(token: signUp.token)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerInvalidToken(response: response, signUpdata: signUp)
            case .failure(let error):
                print("인가 코드 전송 네트워크 오류 : \(error)")
            }
        }
    }
    
    /// 애플 로그인 성공 시 받게 되는 Response 데이터
    /// - Parameter response: response 데이터
    private func handlerInvalidToken(response: Response, signUpdata: SignUpData) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<LoginResponseDetailData>.self, from: response.data)
            DispatchQueue.main.async {
                if decodedData.isSuccess {
                    DispatchQueue.main.async {
                        self.userInfo = UserInfo(accessToken: decodedData.result?.accessToken,
                                                 refreshToken: decodedData.result?.refreshToken,
                                                 email: decodedData.result?.email
                        )
                        let saveData =  self.keychain.saveSession(self.userInfo, for: "userSession")
                        self.isLogin = true
                        print("키 체인 저장 완료 :\(saveData)")
                    }
                } else {
                    self.isLogin = false
                    self.goToSignupPage(signUpdata: signUpdata)
                }
            }
        } catch {
            print("토큰 디코더 오류 : \(error)")
        }
    }
    
    // MARK: - Navigation
    
    private func goToSignupPage(signUpdata: SignUpData) {
        self.container.navigationRouter.push(to: .signUp(token: signUpdata.token, name: signUpdata.name, email: signUpdata.email))
    }
    
}
