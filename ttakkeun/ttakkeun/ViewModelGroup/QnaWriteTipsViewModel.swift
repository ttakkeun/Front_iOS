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
    
    @Published var requestData: QnaTipsRequestData? = QnaTipsRequestData(category: .all, title: "", content: "")
    @Published var responseData: QnaTipsData?
    @Published var isTipsinputCompleted: Bool = false
  

    
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
   
    func checkFilledStates() {
        isTipsinputCompleted = (requestData?.title.isEmpty == false) && (requestData?.content.isEmpty == false)
    }
    
    
    
//    내가 해야하는 일
//    1. 일단, Data저장하고 포스트 해야함
//    - 먼저 responsehandler만들고
//    - 그리고 postInputdata()만들기
//    - 사진 보내는 함수도 만들어야함~
    
    
    
    //MARK: - AppendImage Function
    @Published var isImagePickerPresented: Bool = false
    @Published var arrImages: [UIImage] = []

    var selectedImageCount: Int {
        arrImages.count
    }
    
    func addImage(_ images: UIImage) {
        arrImages.append(images)
    }
    
    func removeImage(at index: Int) {
        if arrImages.indices.contains(index) {
            arrImages.remove(at: index)
        }
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        arrImages
    }
     
    
    //MARK: - API Function
    func postTipsData() async {
         guard let data = self.requestData else { return }
         provider.request(.createTipsContent(data: data)) { [weak self] result in
             switch result {
             case .success(let response):
                 self?.handlerResponsepostTipsData(response: response)
                 // 사진도 포스트합니다.
                 if let images = self?.arrImages, !images.isEmpty {
                     self?.postImages(images: images)
                 }
             case .failure(let error):
                 print("네트워크 에러: \(error)")
             }
         }
     }

     private func handlerResponsepostTipsData(response: Response) {
         do {
             let decodedData = try JSONDecoder().decode(QnaTipsData.self, from: response.data)
             DispatchQueue.main.async {
                 self.responseData = decodedData
                 print("Tips 포스트 성공")
             }
         } catch {
             print("Tips 디코딩 에러: \(error)")
         }
     }

     private func postImages(images: [UIImage]) {
         provider.request(.sendTipsImage(images: images)) { result in
             switch result {
             case .success(let response):
                 print("이미지 업로드 성공: \(response.statusCode)")
             case .failure(let error):
                 print("이미지 업로드 실패: \(error)")
             }
         }
     }
 }
