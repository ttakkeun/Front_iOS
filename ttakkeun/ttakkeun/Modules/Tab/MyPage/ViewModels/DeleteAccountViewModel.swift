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
    let appleLoginManager: AppleLoginManager = .init()
    var cancellalbes = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
    /// 로그 아웃 및 회원탈퇴 시 처리
    private func clearUserInfo() {
        AppStorageKey.allKeys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
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
        container.useCaseProvider.authUseCase.executeDeleteKakaoAccount()
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
                KeyChainManager.standard.deleteSession(for: KeyChainManager.keyChainSession)
                #if DEBUG
                print("카카오 회원 탈퇴 완료 :\(responseData)")
                #endif
            })
            .store(in: &cancellalbes)
    }
    
    /// 애플 계정 삭제
    /// - Parameter code: 계정 코드
    private func deleteAppleAccount(code: String) {
        container.useCaseProvider.authUseCase.executeDeleteAppleAccount(authorizationCode: code)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("apple Delete Account Completed")
                case .failure(let failure):
                    print("apple Delete Account Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                self?.clearUserInfo()
                KeyChainManager.standard.deleteSession(for: KeyChainManager.keyChainSession)
                #if DEBUG
                print("애플 회원 탈퇴 완료 :\(responseData)")
                #endif
            })
            .store(in: &cancellalbes)
    }
}
