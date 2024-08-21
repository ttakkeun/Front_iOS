//
//  ProfileImageRegistPicker.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct HomeProfilePatchImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petState: PetState
    var imageHandler: HomePatchImage
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, imageHandler: imageHandler, petState: petState)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: HomeProfilePatchImagePicker
        var imageHandler: HomePatchImage
        var petState: PetState
        
        init(_ parent: HomeProfilePatchImagePicker, imageHandler: HomePatchImage, petState: PetState) {
            self.parent = parent
            self.imageHandler = imageHandler
            self.petState = petState
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.parent.dismiss()
            
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.imageHandler.sendImageToServer(image, self.petState.petId)
                        }
                    }
                }
            }
        }
    }
}
