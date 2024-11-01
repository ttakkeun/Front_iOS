//
//  MakeProfileViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import Foundation
import SwiftUI

class MakeProfileViewModel: ObservableObject {
    
    @Published var showingVarietySearch = false
    
    // MARK: - Field
    
    @Published var requestData: PetInfo = PetInfo(name: "", type: .dog, variety: "", birth: "", neutralization: false)
    
    @Published var isProfileCompleted: Bool = false
    
    @Published var isNameFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isTypeFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isVarietyFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isBirthFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    @Published var isNeutralizationFieldFilled: Bool = false {
        didSet { checkFilledStates() }
    }
    
    private func checkFilledStates() {
        isProfileCompleted = isNameFieldFilled && isTypeFieldFilled && isVarietyFieldFilled && isBirthFieldFilled && isNeutralizationFieldFilled
    }
    
    
    // MARK: - ImagePicker
    
    var profileImage: [UIImage] = []
    
    @Published var isImagePickerPresented: Bool = false
    
    var selectedImageCount: Int = 0
}

extension MakeProfileViewModel: ImageHandling {
    
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
