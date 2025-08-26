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
    // MARK: - StateProperty
    var isLoading: Bool = false
    var isAgreementCheck: Bool = false
    var isInquireMainBtnClicked: Bool = false
    var isShowAlert: Bool = false
    
    // MARK: - Property
    var myInquiryData: [MyPageMyInquireResponse] = []
    var selectedImageCount: Int {
        return inquirfeImages.count
    }
    
    var inquireText: String = ""
    var emailText: String = ""
    
    
    // MARK: - Image
    var inquirfeImages: [UIImage] = .init()
    var isImagePickerPresented: Bool = false
    
    // MARK: Dependency
    let container: DIContainer
    private var cancellables =  Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Common
    /// 나의 문의 하기 데이터 가져오기
    public func getMyInquire() {
        isLoading = true
        
        container.useCaseProvider.myPageUseCase.executeGetMyInquire()
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoading = false }
                
                switch completion {
                case .finished:
                    print("GetMyInquiry Completed")
                    
                case .failure(let failure):
                    print("GetMyInquiry Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.myInquiryData = responseData
            })
            .store(in: &cancellables)
    }
    
    /// 문의 내용 전달하기
    public func postInquire(inquire: MypageInquireRequest) {
        container.useCaseProvider.myPageUseCase.executePostGenerateInquire(inquire: inquire, imageData: convertImageToData())
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Inquire Completed")
                case .failure(let failure):
                    print("Inquire Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                self?.isShowAlert = true
                #if DEBUG
                print("Inquire Response: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
}

extension InquireViewModel: PhotoPickerHandle {
    func addImage(_ images: [UIImage]) {
        inquirfeImages = images
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
    
    func convertImageToData() -> [Data]? {
        guard !inquirfeImages.isEmpty else { return nil }
        let result = inquirfeImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        return result.isEmpty ? nil : result
    }
}
