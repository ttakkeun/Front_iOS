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

class InquireViewModel: ObservableObject {
    
    @Published var myInquiryData: [MyInquiryResponse] = []
    @Published var isLoading: Bool = false
    
    
    @Published var reportContents: String = ""
    @Published var email: String = ""
    @Published var isAgreementCheck: Bool = false
    @Published var isInquireMainBtnClicked: Bool = false
    
    // MARK: - Image
    
    
    var inqureImages: [UIImage] = []
    
    @Published var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int {
        return inqureImages.count
    }
    
    // MARK: Func & Property
    
    
    let container: DIContainer
    private var cancellables =  Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func makeInquireRequestDto(type: InquiryType) -> InquiryRequestDTO {
        return InquiryRequestDTO(contents: self.reportContents, email: self.email, inquiryType: type)
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

extension InquireViewModel: ImageHandling {
    
    func addImage(_ images: UIImage) {
        if inqureImages.count < 3 {
            let downSampleImage = images.downSample(scale: 0.5)
            DispatchQueue.main.async {
                self.inqureImages.append(downSampleImage)
            }
        }
    }
    
    func removeImage(at index: Int) {
        inqureImages.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        return inqureImages
    }
}
