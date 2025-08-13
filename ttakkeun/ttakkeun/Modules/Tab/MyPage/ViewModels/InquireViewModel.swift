//
//  InquireViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/22/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya

@Observable
class InquireViewModel {
    
    var myInquiryData: [MyInquiryResponse] = []
    var isLoading: Bool = false
    
    
    var inquireText: String = ""
    var emailText: String = ""
    var isAgreementCheck: Bool = false
    var isInquireMainBtnClicked: Bool = false
    
    // MARK: - Image
    var inquirfeImages: [UIImage] = .init()
    
    var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int {
        return inquirfeImages.count
    }
    
    // MARK: Func & Property
    
    
    let container: DIContainer
    private var cancellables =  Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func makeInquireRequestDto(type: InquireType) -> InquiryRequestDTO {
        return InquiryRequestDTO(contents: self.inquireText, email: self.emailText, inquiryType: type)
    }
    
    public func getMyInquire() {
        
        isLoading = true
        
        container.useCaseProvider.myPageUseCase.executeGetMyInquir()
            .tryMap { responseData -> ResponseData<[MyInquiryResponse]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ GetMyInquiry: \(String(describing: responseData.result))")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                isLoading = false
                
                switch completion {
                case .finished:
                    print("✅ GetMyInquiry Completed")
                    
                case .failure(let failure):
                    print("❌ GetMyInquiry Failure: \(failure)")
                }
                
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let responseData = responseData.result {
                    self.myInquiryData = responseData
                }
            })
            .store(in: &cancellables)
    }
}

extension InquireViewModel: PhotoPickerHandle {
    func addImage(_ images: [UIImage]) {
        print("이미지")
    }
    
    func removeImage(at index: Int) {
        inquirfeImages.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        return inquirfeImages
    }
}
