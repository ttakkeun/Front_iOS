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
    }
    
    
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
