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
    @Published private var isShowTipsWriteView: Bool = false
    
    let category: PartItem?
    
    init(category: PartItem?) {
        self.category = category
    }
    
    public func changeIsShowTipsWriteView() {
        isShowTipsWriteView.toggle()
    }
    
    // MARK: - ImageHandling
    
    @Published var isImagePickerPresented: Bool = false
    @Published private var selectedImage: [UIImage] = []
    
    var selectedImageCount: Int = 0
    
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
