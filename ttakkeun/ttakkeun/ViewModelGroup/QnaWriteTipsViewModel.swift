//
//  QnaWriteTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/11/24.
//

import Foundation
import SwiftUI
import Moya

@MainActor
class QnaWriteTipsViewModel: ObservableObject, @preconcurrency ImageHandling {
    
    @Published var inputData: QnaTipsRequestData?
    @Published var responseData: QnaTipsData?
    @Published var isTipsinputCompleted: Bool = false
    @Published var selectedImages: [UIImage] = []

    
    private let provider: MoyaProvider<QnaTipsAPITarget>
   
    //MARK: - Init
    init(isTipsinputCompleted: Bool = false ,
         provider:
         MoyaProvider<QnaTipsAPITarget> =
         APIManager.shared.testProvider(for: QnaTipsAPITarget.self)
    ) {
        self.isTipsinputCompleted = isTipsinputCompleted
        self.provider = provider
    }
    
    
    @Published var Title: Bool = false {
        didSet { checkFilledStates() }
    }
    @Published var Content: Bool = false {
        didSet { checkFilledStates() }
    }
    
    private func checkFilledStates() {
        isTipsinputCompleted = Title && Content
    }
    
    
    
//    내가 해야하는 일
//    1. 일단, Data저장하고 포스트 해야함
//    - 먼저 responsehandler만들고
//    - 그리고 postInputdata()만들기
//    - 사진 보내는 함수도 만들어야함~
    
    
    
    //MARK: - AppendImage Function
    @Published var isImagePickerPresented: Bool = false

    func addImage(_ images: UIImage) {
        if selectedImages.count < 3 {
            selectedImages.append(images)
        }
    }

      func removeImage(at index: Int) {
          if selectedImages.indices.contains(index) {
              selectedImages.remove(at: index)
          }
      }
      
      func showImagePicker() {
          isImagePickerPresented = true
      }
      
      func getImages() -> [UIImage] {
          selectedImages
      }
    
 
    
    
     var selectedImageCount: Int {
         selectedImages.count
     }
     
    
    //MARK: - API Function
    private func postTipsData() async {
        guard let data = self.inputData else { return }
        provider.request(.createTipsContent(data: data)) {[weak self]
            result in
            switch result {
            case . success(let response):
                self?.handlerResponsepostTipsData(response: response)
            case .failure(let error):
                print("네트워크에러 \(error)")
            }
        }
    }

    private func handlerResponsepostTipsData(response: Response) {
        do {
            let decodedData = try
            JSONDecoder().decode(QnaTipsData.self, from: response.data)
            DispatchQueue.main.async {
                self.responseData = decodedData
                print("Tips")
            }
        } catch {
            print("TIps")
            
        }
    }
    
    
    
}
