//
//  ImageHandlign.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import Foundation
import SwiftUI

// FIXME: - 삭제 필요
protocol ImageHandling: AnyObject {
    func addImage(_ images: UIImage)
    func removeImage(at index: Int)
    func showImagePicker()
    func getImages() -> [UIImage]
    
    var isImagePickerPresented: Bool { get set }
    var selectedImageCount: Int { get }
 }

protocol PhotoPickerHandle: AnyObject {
    func addImage(_ images: [UIImage])
    func removeImage(at index: Int)
    func getImages() -> [UIImage]
    
    var isImagePickerPresented: Bool { get set }
    var selectedImageCount: Int { get }
}
