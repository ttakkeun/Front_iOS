//
//  DeleteAccountViewModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation
import Combine
import CombineMoya

@Observable
class DeleteAccountViewModel {
    var currentPage: DeletePageType = .firstPage
    var etcReason: String = ""
    var selectedReasons: Set<DeleteReasonType> = .init()
    
    // MARK: - CheckProperty
    var isAgreementCheck: Bool = false
    var isMyAccountCheck: Bool = false
    
    // MARK: - Dependency
    var container: DIContainer
    var appFlowViewModel: AppFlowViewModel
    let appleLoginManager: AppleLoginManager = .init()
    var cancellalbes = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer, appFlowViewModel: AppFlowViewModel) {
        self.container = container
        self.appFlowViewModel = appFlowViewModel
    }
    
    // MARK: - Common
    /// 로그 아웃 및 회원탈퇴 시 처리
    private func clearUserInfo() {
        AppStorageKey.allKeys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
    }
    
    private func deleteUser() {
        KeyChainManager.standard.deleteSession(for: KeyChainManager.keyChainSession)
        appFlowViewModel.deleteAccount()
        container.navigationRouter.popToRootView()
    }
    
    /// 프로필 삭제 삭제
    private func clearProfile() {
        UserDefaults.standard.removeObject(forKey: AppStorageKey.petId)
        UserDefaults.standard.removeObject(forKey: AppStorageKey.petName)
        UserDefaults.standard.removeObject(forKey: AppStorageKey.petType)
    }
    
    public func deleteKakao() {
        self.deleteKakaoAccount()
    }
    
    public func deleteApple() {
        appleLoginManager.onAccountDeleteAuthorized = { code in
            self.deleteAppleAccount(code: code)
        }
        
        appleLoginManager.accountDelete()
    }
    
    // MARK: DeleteAccount
    /// 카카오 계정 삭제
    private func deleteKakaoAccount() {
        container.useCaseProvider.authUseCase.executeDeleteKakaoAccount(kakaoDelete: convertDeleteRequest())
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("kakao Delete Account Completed")
                case .failure(let failure):
                    print("kakao Delete Account Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                self?.clearUserInfo()
                self?.deleteUser()
                #if DEBUG
                print("카카오 회원 탈퇴 완료 :\(responseData)")
                #endif
            })
            .store(in: &cancellalbes)
    }
    
    /// 애플 계정 삭제
    /// - Parameter code: 계정 코드
    private func deleteAppleAccount(code: String) {
        container.useCaseProvider.authUseCase.executeDeleteAppleAccount(appleDelete: convertDeleteRequest(), code: code)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("apple Delete Account Completed")
                case .failure(let failure):
                    print("deleteRequest 출력 : \(convertDeleteRequest())")
                    print("apple Delete Account Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                self?.clearUserInfo()
                self?.deleteUser()
                #if DEBUG
                print("애플 회원 탈퇴 완료 :\(responseData)")
                #endif
            })
            .store(in: &cancellalbes)
    }
    
    /// 삭제 Request 변환 함수
    /// - Returns: 삭제 값 반환
    private func convertDeleteRequest() -> DeleteRequest {
        if let firstReason = selectedReasons.first {
            return .init(reasonType: firstReason, customReason: etcReason, valid: true)
        } else {
            return .init(reasonType: .other, customReason: etcReason, valid: true)
        }
    }
}
