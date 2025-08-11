//
//  ReportViewModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/11/25.
//

import Foundation
import SwiftUI

@Observable
class ReportViewModel: PhotoPickerHandle {
    var isImagePickerPresented: Bool = false
    var contentsText: String = ""
    var selectedImageCount: Int = .zero
    var selectedImage: [UIImage] = .init()
    
    var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func addImage(_ images: [UIImage]) {
        print("hello")
    }
    
    func removeImage(at index: Int) {
        print("hello")
    }
    
    func getImages() -> [UIImage] {
        return [UIImage.againIcon]
    }
}
