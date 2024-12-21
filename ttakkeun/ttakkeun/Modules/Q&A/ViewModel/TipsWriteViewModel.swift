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

class TipsWriteViewModel: ObservableObject, ImageHandling {
    
    @Published var title: String = ""
    @Published var textContents: String = ""
    
    @Published var isImagePickerPresented: Bool = false
    @Published private var selectedImage: [UIImage] = []
    
    @Published var registTipsLoading: Bool = false
    
    var selectedImageCount: Int = 0
    
    let category: ExtendPartItem
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private func makeWriteTipsRequest() -> WriteTipsRequest {
        return WriteTipsRequest(title: title, content: textContents, category: category.toPartItemRawValue() ?? "EAR")
    }
    
    // MARK: - ImageHandling
}

extension TipsWriteViewModel {
    
    func addImage(_ images: UIImage) {
        selectedImage.append(images)
    }
    
    func removeImage(at index: Int) {
        selectedImage.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented.toggle()
    }
    
    func getImages() -> [UIImage] {
        selectedImage
    }
}

extension TipsWriteViewModel {
    public func writeTips() {
        registTipsLoading = true
        
        print("팁스 생성 데이터: \(makeWriteTipsRequest())")
        
        container.useCaseProvider.qnaUseCase.executeWriteTipsData(data: makeWriteTipsRequest())
            .tryMap { responseData -> ResponseData<TipsResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ WriteTips Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    print("✅ WriteTips Server Completed")
                case .failure(let failure):
                    print("❌ WriteTips Server failure: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                    if !selectedImage.isEmpty {
                        if let responseData = responseData.result {
                            patchTipsImage(tipId: responseData.tipId)
                        }
                    } else {
                        registTipsLoading = false
                        print("✅ WriteTipsResponse: \(String(describing: responseData.result))")
                    }
                
                self.goToBeforePage()
            })
            .store(in: &cancellables)
    }
    
    private func patchTipsImage(tipId: Int) {
        container.useCaseProvider.qnaUseCase.executePatchTipsImage(tipId: tipId, images: getImages())
            .tryMap { responseData -> ResponseData<[String]> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("✅ PatchTips Image Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                registTipsLoading = false
                switch completion {
                case .finished:
                    print("✅ PatchTIps Image Completed")
                case .failure(let failure):
                    print("❌ PatchTIps Image Failure: \(failure)")
                }
            },
                  receiveValue: { responseData in
                if let responseData = responseData.result {
                    print("PatchTips Image Response: \(responseData)")
                }
            })
            .store(in: &cancellables)
    }
}
