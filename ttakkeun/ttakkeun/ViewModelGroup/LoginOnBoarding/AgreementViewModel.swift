//
//  AgreementViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/13/24.
//

import SwiftUI
import Combine
import Moya

@MainActor
class AgreementViewModel: ObservableObject {
    @Published var agreements: [AgreementData] = []
    @Published var selectedAgreement: AgreementData?
    
    private let provider: MoyaProvider<UserLoginAPITarget>
    var userInfo = UserInfo()
    private let keychain = KeyChainManager.standard
    
    //MARK: - INIT
    init(
        provider: MoyaProvider<UserLoginAPITarget> = APIManager.shared.createProvider(for: UserLoginAPITarget.self)
    ) {
        self.provider = provider
        loadAgreements()
    }
    
    //MARK: - Variable
    /// 모든 항목이 체크되었는지 확인
    var isAllChecked: Bool {
        agreements.allSatisfy { $0.isChecked }
    }
    
    /// 필수 항목들이 모두 체크되었는지 확인
    var isAllMandatoryChecked: Bool {
        agreements.filter { $0.isMandatory }.allSatisfy { $0.isChecked }
    }
    
    //MARK: - Function
    /// 특정 동의 항목의 체크 상태를 토글하는 함수
    func toggleCheck(for item: AgreementData) {
        if let index = agreements.firstIndex(where: { $0.id == item.id }) {
            agreements[index].isChecked.toggle()
        }
    }
    
    /// 모든 동의 항목의 체크 상태를 토글하는 함수
    func toggleAllAgreements() {
        /// 현재 모든 항목이 체크되었는지 여부에 따라 새로운 값을 설정
        let newValue = !isAllChecked
        for index in agreements.indices {
            agreements[index].isChecked = newValue
        }
    }
    
    /// 동의 항목 데이터를 로드하는 함수
    private func loadAgreements() {
        agreements = AgreementDetailData.loadAgreements()
    }
    
    public func signUp(token: String, name: String) async {
        return await withCheckedContinuation { continuation in
            provider.request(.appleSignup(token: token, name: name)) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.handlerSignUp(response: response)
                    continuation.resume(returning: ())
                case .failure(let error):
                    print("회원강립 네트워크 에러: \(error)")
                }
            }
        }
    }
    
    private func handlerSignUp(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<SignUpResponseData>.self, from: response.data)
            print(decodedData)
            if decodedData.isSuccess {
                DispatchQueue.main.async {
                    self.userInfo = UserInfo(accessToken: decodedData.result?.accessToken,
                                             refreshToken: decodedData.result?.refreshToken)
                    let saveData =  self.keychain.saveSession(self.userInfo, for: "userSession")
                    print("회원 가입 성공: \(saveData)")
                }
            }
        } catch {
            print("회원가입 디코더 에러: \(error)")
        }
    }
}
