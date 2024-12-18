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

class MyPageViewModel: ObservableObject {
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        
        self.getUserInfo()
    }
    
    @Published var userInfo: UserInfoResponse?
    @Published var isLoading: Bool = false
    
    var cancellalbes = Set<AnyCancellable>()
    
    
    // MARK: - ImagePicker
    
    
    var profileImage: [UIImage] = []
    
    @Published var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int = 0
}

extension MyPageViewModel: ImageHandling {
    
    func addImage(_ images: UIImage) {
        if !profileImage.isEmpty {
            profileImage.removeAll()
        }
        
        profileImage.append(images)
    }
    
    func removeImage(at index: Int) {
        profileImage.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        profileImage
    }
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
                
                isLoading = true
                
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
                    print("getUserName Completed")
                case .failure(let failure):
                    print("getUserName Failed: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let _ = responseData.result {
                    getUserInfo()
                }
            })
            .store(in: &cancellalbes)
    }
}
