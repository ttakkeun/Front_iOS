//
//  QnaWriteTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/11/24.
//

import Foundation
import SwiftUI
import Moya

/// Tip내용을 공유하는 기능들이 모여있는 뷰모델
@MainActor
class QnaWriteTipsViewModel: ObservableObject, @preconcurrency ImageHandling {

    @Published var requestData: QnaTipsRequestData? = QnaTipsRequestData(category: .all, title: "", content: "")
    @Published var responseData: QnaPostTipsData?
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

    //MARK: - 텍스트필드 점검 함수
    @Published var Title: Bool = false {
        didSet { checkFilledStates() }
    }
    @Published var Content: Bool = false {
        didSet { checkFilledStates() }
    }

    func checkFilledStates() {
        isTipsinputCompleted = (requestData?.title.isEmpty == false) && (requestData?.content.isEmpty == false)
    }

    //MARK: - AppendImage Function
    @Published var isImagePickerPresented: Bool = false
    @Published var arrImages: [UIImage] = []

    var selectedImageCount: Int {
        arrImages.count
    }

    func addImage(_ image: UIImage) {
        arrImages.append(image)
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
    /// Tip내용 Post하는 함수
    func postTipsData() async {
        guard let data = self.requestData else { return }

        provider.request(.createTipsContent(title: data.title, content: data.content, category: data.category.rawValue)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handlerResponsePostTipsData(response: response)
                if let images = self?.arrImages, !images.isEmpty {
                    _Concurrency.Task {
                        await self?.postImages()
                    }
                }
            case .failure(let error):
                print("네트워크 에러: \(error)")
            }
        }
    }


    /// Tip내용 핸들러 함수
    /// - Parameter response: API 호출 시 받게 되는 응답
    private func handlerResponsePostTipsData(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(QnaPostTipsData.self, from: response.data)
            DispatchQueue.main.async {
                self.responseData = decodedData
                print("Tips 데이터 포스트 성공")
            }
        } catch {
            print("Tips 디코딩 에러: \(error)")
        }
    }

    /// 선택한 이미지 전송하는 함수
    private func postImages() async {
        guard let tipId = responseData?.result.tip_id else {
            print("postImages() 실패: tip_id를 찾을 수 없음")
            return
        }
        
        print("postImages() 시작: \(tipId)")
        
        provider.request(.sendTipsImage(tip_id: tipId, images: arrImages)) { result in
            switch result {
            case .success(let response):
                print("이미지 업로드 성공: \(response.statusCode)")
            case .failure(let error):
                print("이미지 업로드 실패: \(error)")
            }
        }
    }
}
