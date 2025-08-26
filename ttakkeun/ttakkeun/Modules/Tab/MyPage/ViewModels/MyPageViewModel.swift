//
//  MyPageViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya

@Observable
class MyPageViewModel {
    // MARK: - StateProperty
    var isLoading: Bool = false
    
    // MARK: - Property
    var editNicknameValue: String = ""
    var userInfo: MyPageUserInfoResponse?
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    // MARK: - Dependency
    let container: DIContainer
    var cancellalbes = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
        self.getUserInfo()
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
    
    // MARK: - UserAPI
    /// 유저 정보 조회
    func getUserInfo() {
        isLoading = true
        
        container.useCaseProvider.myPageUseCase.executeGetUserInfo()
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoading = false }
                switch completion {
                case .finished:
                    print("getUserInfo Completed")
                case .failure(let failure):
                    print("getUserInfo Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                userInfo = responseData
            })
            .store(in: &cancellalbes)
    }
    
    /// 닉네임 변경
    /// - Parameter newUsername: 유저 닉네임
    func editName() {
        container.useCaseProvider.myPageUseCase.executePatchEditUserName(newUsername: editNicknameValue)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Edit UserName Completed")
                case .failure(let failure):
                    print("Edit UserName Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                userInfo?.username = editNicknameValue
            })
            .store(in: &cancellalbes)
    }
    
    // MARK: - AccountAPI
    /// 로그아웃
    func logout() {
        container.useCaseProvider.authUseCase.executeLogout()
            .validateResult()
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .finished:
                    print("logout Completed")
                case .failure(let error):
                    print("logout Failed: \(error)")
                }
            }, receiveValue: { [weak self] responseData in
                self?.clearUserInfo()
                KeyChainManager.standard.deleteSession(for: KeyChainManager.keyChainSession)
            })
            .store(in: &cancellalbes)
    }
    
    /// 프로필 삭제
    func deleteProfile() {
        container.useCaseProvider.petProfileUseCase.executeDeletePetprofile(petId: petId)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("UserProfileDelete Completed")
                case .failure(let failure):
                    print("UserProfileDelete Failed: \(failure)")
                }
            }, receiveValue: { _ in
                self.clearProfile()
            })
            .store(in: &cancellalbes)
    }
}
