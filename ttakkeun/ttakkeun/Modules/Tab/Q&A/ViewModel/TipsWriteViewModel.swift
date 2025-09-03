//
//  TipsWriteViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya
import PhotosUI

@Observable
class TipsWriteViewModel {
    // MARK: - StateProperty
    var isImagePickerPresented: Bool = false
    var registTipsLoading: Bool = false
    
    // MARK: - Constants
    var title: String = ""
    var textContents: String = ""
    let category: ExtendPartItem
    
    // MARK: - ImageProperty
    var imageItems: [PhotosPickerItem] = []
    var selectedImage: [UIImage] = []
    var selectedImageCount: Int = 0
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(category: ExtendPartItem,
         container: DIContainer
    ) {
        self.category = category
        self.container = container
    }
    
    // MARK: - NavigationFunction
    public func goToBeforePage() {
        container.navigationRouter.pop()
    }
    
    private func makeWriteTipsRequest() -> TipGenerateRequest {
        let partItem: PartItem
        if case let .part(item) = category {
            partItem = item
        } else {
            partItem = .ear
        }
        return .init(title: title, content: textContents, category: partItem)
    }
    
    // MARK: - Image
    public func convertPickerItemsToUIImages(items: [PhotosPickerItem]) {
        var loadedImages: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for item in items {
            dispatchGroup.enter()
            item.loadTransferable(type: Data.self) {result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        loadedImages.append(image)
                    }
                case .failure(let error):
                    print("이미지 변환 에러: \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            self.addImage(loadedImages)
        })
    }
    
    // MARK: - Tip API
    /// 팁 작성 API
    public func writeTips() {
        registTipsLoading = true
        
        container.useCaseProvider.tipUseCase.executePostGenerateTipData(tip: makeWriteTipsRequest())
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("WriteTips Server Completed")
                case .failure(let failure):
                    print("WriteTips Server failure: \(failure)")
                    self.registTipsLoading = false
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                    if !selectedImage.isEmpty {
                        patchTipsImage(tipId: responseData.tipId)
                    } else {
                        print("WriteTipsResponse: \(String(describing: responseData))")
                        self.registTipsLoading = false
                        self.goToBeforePage()
                    }
            })
            .store(in: &cancellables)
    }
    
    /// 팁 이미지 업로드
    /// - Parameter tipId: 팁 아이디
    private func patchTipsImage(tipId: Int) {
        container.useCaseProvider.tipUseCase.executePatchTipsImageData(tipId: tipId, images: convertImageToData())
            .validateResult()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { registTipsLoading = false }
                switch completion {
                case .finished:
                    print("PatchTIps Image Completed")
                case .failure(let failure):
                    print("PatchTIps Image Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.goToBeforePage()
                #if DEBUG
                print("PatchTips Image Response: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
}

extension TipsWriteViewModel: PhotoPickerHandle {
    func addImage(_ images: [UIImage]) {
        self.selectedImage = images
    }
    
    func removeImage(at index: Int) {
        self.selectedImage.remove(at: index)
        if imageItems.indices.contains(index) {
            imageItems.remove(at: index)
        }
    }
    
    func getImages() -> [UIImage] {
        return self.selectedImage
    }
    
    func convertImageToData() -> [Data] {
        return selectedImage.compactMap { $0.jpegData(compressionQuality: 0.8) }
    }
}
