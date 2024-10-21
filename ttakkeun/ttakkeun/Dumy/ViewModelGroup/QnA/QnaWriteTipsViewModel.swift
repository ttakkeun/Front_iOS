//
//  QnaWriteTipsViewModel.swift
//  ttakkeun
//
//  Created by 한지강 on 8/11/24.
//

// QnaWriteTipsViewModel.swift

import Foundation
import SwiftUI
import Moya

@MainActor
class QnaWriteTipsViewModel: ObservableObject, @preconcurrency ImageHandling {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var requestData: QnaTipsRequestData?
    @Published var responseData: QnaPostTipsData?
    @Published var isTipsInputCompleted: Bool = false

    private let provider: MoyaProvider<QnaTipsAPITarget>
    private let category: TipsCategorySegment

    //MARK: - Init
    init(category: TipsCategorySegment, provider: MoyaProvider<QnaTipsAPITarget> = APIManager.shared.createProvider(for: QnaTipsAPITarget.self)) {
        self.category = category
        self.requestData = QnaTipsRequestData(category: category, title: "", content: "")
        self.provider = provider
    }

    //MARK: - 텍스트필드 점검 함수
    func checkFilledStates() {
        isTipsInputCompleted = !title.isEmpty && !content.isEmpty
        if isTipsInputCompleted {
            requestData?.title = title
            requestData?.content = content
        }
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
        guard self.requestData != nil else { return }

        print("POST Data: Title = \(title), Content = \(content), Category = \(category.rawValue)")

        do {
            let result = try await postTipContent()
            switch result {
            case .success(let response):
                self.handlerResponsePostTipsData(response: response, completion: {
                    if !self.arrImages.isEmpty {
                        _Concurrency.Task {
                            await self.postImages()
                        }
                    }
                })
            case .failure(let error):
                print("Network error: \(error)")
            }
        } catch {
            print("Error posting data: \(error)")
        }
    }


    private func postTipContent() async throws -> Result<Response, MoyaError> {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.createTipsContent(content: content, title: title, category: category.rawValue)) { result in
                continuation.resume(with: .success(result))
            }
        }
    }

    /// Tip내용 핸들러 함수
    /// - Parameter response: API 호출 시 받게 되는 응답
    private func handlerResponsePostTipsData(response: Response, completion: @escaping () -> Void) {
        do {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }
            let decodedData = try JSONDecoder().decode(QnaPostTipsData.self, from: response.data)
            DispatchQueue.main.async {
                self.responseData = decodedData
                print("Tips 데이터 포스트 성공")
                print("Received tipId: \(String(describing: decodedData.result?.tipId))")
                completion()
            }
        } catch {
            print("Tips 디코딩 에러: \(error)")
        }
    }

    /// 선택한 이미지 전송하는 함수
    private func postImages() async {
        guard let tipId = responseData?.result?.tipId else {
            print("postImages() 실패: tip_id를 찾을 수 없음")
            return
        }

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
