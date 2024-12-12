//
//  TipsWriteViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import Foundation
import SwiftUI

class TipsWriteViewModel: ObservableObject, ImageHandling {
    
    @Published var title: String = ""
    @Published var textContents: String = ""
    
    let category: ExtendPartItem
    let container: DIContainer
    
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
    
    
    @Published var isImagePickerPresented: Bool = false
    @Published private var selectedImage: [UIImage] = []
    
    var selectedImageCount: Int = 0
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
