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
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        
        self.getUserInfo()
    }
    
    var userInfo: UserInfoResponse?
    var isLoading: Bool = false
    
    var inputNickname: String = ""
    
    var cancellalbes = Set<AnyCancellable>()
}

extension MyPageViewModel {
    
    func getUserInfo() {
        isLoading = true
        
        container.useCaseProvider.myPageUseCase.executeMyPage()
            .tryMap { responseData -> ResponseData<UserInfoResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("getUserInfo Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                isLoading = false
                
                switch completion {
                case .finished:
                    print("getUserInfo Completed")
                case .failure(let failure):
                    print("getUserInfo Failed: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                
                guard let self = self else { return }
                
                if let reponseData = responseData.result {
                    userInfo = reponseData
                }
            })
            .store(in: &cancellalbes)
    }
    
    func editName(newUsername: String) {
        container.useCaseProvider.myPageUseCase.executeEditUserNameDate(newUsername: newUsername)
            .tryMap { responseData -> ResponseData<String> in
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
                    print("Edit UserName Completed")
                case .failure(let failure):
                    print("Edit UserName Failed: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let result = responseData.result {
                    UserState.shared.setUserName(result)
                    getUserInfo()
                }
            })
            .store(in: &cancellalbes)
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        container.useCaseProvider.myPageUseCase.executeLogout()
            .tryMap { responseData -> ResponseData<String> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .finished:
                    KeyChainManager.standard.deleteSession(for: "ttakkeunUser")
                    completion(.success(()))
                case .failure(let error):
                    // 실패 시 Result<Void, Error>에서 에러를 반환
                    completion(.failure(error))
                }
            }, receiveValue: { responseData in
                if let _ = responseData.result {
                    
                }
            })
            .store(in: &cancellalbes)
    }
    
    func deleteProfile() {
        container.useCaseProvider.myPageUseCase.executeDeleteProfile(petId: UserState.shared.getPetId())
            .tryMap { responseData -> ResponseData<EmptyResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("UserProfileDelete")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("UserProfileDelete Completed")
                case .failure(let failure):
                    print("UserProfileDelete Failed: \(failure)")
                }
            },
                  receiveValue: {responseData in
                
                if let _ = responseData.result {
                    UserState.shared.clearProfile()
                }
            })
            .store(in: &cancellalbes)
    }
}
