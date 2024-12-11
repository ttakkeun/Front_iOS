//
//  JournalRegistViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import Foundation
import SwiftUI
import UIKit
import ImageIO
import Combine
import CombineMoya
import Moya

class JournalRegistViewModel: ObservableObject {

    @Published var currentPage: Int = 1
    @Published var selectedPart: PartItem?
    
    @Published var getQuestions: JournalQuestionResponse?
    @Published var selectedAnswerData: SelectedAnswerRequest
    @Published var isNextEnabled: Bool = false
    
    @Published var isImagePickerPresented: Bool = false
    @Published var questionImages: [Int: [UIImage]] = [:]
    
    @Published var questionIsLoading: Bool = false
    @Published var makeJournalsLoading: Bool = false
    
    @Published var isNextEnalbes:Bool = false
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(petID: Int, container: DIContainer) {
        selectedAnswerData = .init(petId: petID)
        self.container = container
    }
    
    var selectedImageCount: Int {
        guard let questionID = currentQuestion?.questionID else { return 0 }
        return questionImages[questionID]?.count ?? 0
    }
    
    var currentQuestion: QuestionDetailData? {
        guard let getQuestion = getQuestions, currentPage - 1 <= getQuestion.question.count else { return nil }
        return getQuestion.question[currentPage - 2]
    }
    
    func updateAnswer(for questionID: Int, selectedAnswer: [String]) {
        selectedAnswerData.answers[questionID] = selectedAnswer
    }
    
    
}

extension JournalRegistViewModel: ImageHandling {
    func addImage(_ images: UIImage) {
        guard let questionId = currentQuestion?.questionID else { return }
        if questionImages[questionId]?.count ?? 0 < 5 {
            DispatchQueue.global(qos: .userInitiated).async {
                let downSampledImage = images.downSample(scale: 0.5)
                DispatchQueue.main.async {
                    self.questionImages[questionId, default: []].append(downSampledImage)
                }
            }
        }
    }
    
    func removeImage(at index: Int) {
        guard let questionID = currentQuestion?.questionID else { return }
        questionImages[questionID]?.remove(at: index)
    }
    
    func showImagePicker() {
        DispatchQueue.main.async {
            self.isImagePickerPresented.toggle()
        }
    }
    
    func getImages() -> [UIImage] {
        guard let questionID = currentQuestion?.questionID else { return [] }
        return questionImages[questionID] ?? []
    }
}

// MARK: - RegistJournalAPI

extension JournalRegistViewModel {
    public func getAnswerList() {
        if let selectedPart = selectedPart {
            questionIsLoading = true
            
            container.useCaseProvider.journalUseCase.executeGetAnswerListData(category: selectedPart.rawValue)
                .tryMap { responseData -> ResponseData<JournalQuestionResponse> in
                    if !responseData.isSuccess {
                        throw APIError.serverError(message: responseData.message, code: responseData.code)
                    }
                    
                    guard let _ = responseData.result else {
                        throw APIError.emptyResult
                    }
                    
                    print("AnswerList Server: \(responseData)")
                    return responseData
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    questionIsLoading = false
                    
                    switch completion {
                    case .finished:
                        print("Get Answer List Completed")
                    case .failure(let failure):
                        print("Get Answer List Failure: \(failure)")
                    }
                },
                      receiveValue: { [weak self] responseData in
                    guard let self = self else { return }
                    
                    getQuestions = responseData.result
                })
                .store(in: &cancellables)
        }
    }
    
    public func makeJournal() {
        if let selectedPart = selectedPart {
            makeJournalsLoading = true
            
            container.useCaseProvider.journalUseCase.executeMakeJournal(category: selectedPart.rawValue, data: selectedAnswerData, questionImage: questionImages)
                .tryMap { responseData -> ResponseData<MakeJournalResultResponse> in
                    
                    if !responseData.isSuccess {
                        throw APIError.serverError(message: responseData.message, code: responseData.code)
                    }
                    
                    guard let _ = responseData.result else {
                        throw APIError.emptyResult
                    }
                    
                    print("MakeJournal Server: \(responseData)")
                    return responseData
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Make Journal Completed")
                    case .failure(let failure):
                        print("Make Journal failure: \(failure.localizedDescription)")
                    }
                },
                      receiveValue: { [weak self] responseData in
                    guard let self = self else { return }
                    print("생성된 일지: \(String(describing: responseData.result))")
                    makeJournalsLoading = false
                    container.navigationRouter.pop()
                })
                .store(in: &cancellables)
        }
    }
}


extension UIImage {
    /// 이미지 사이즈 조절, 데이터 타입으로 변환 후 리사징하기 떄문애 메모리 절약 효율적!!
    /// 자세한 건 공지한 노션에 올려두었으니 꼭 읽어보시길 바랍니다
    /// - Parameter scale: 이미지 자체 이미지를 1이라 정하고, 얼마큼 줄일것인지 스케일을 입력!!
    /// - Returns: 스케일을 통해 리사이징된 이미지 반환
    func downSample(scale: CGFloat) -> UIImage {
        _ = [kCGImageSourceShouldCache: false] as CFDictionary
            let data = self.pngData()! as CFData
            let imageSource = CGImageSourceCreateWithData(data, nil)!
            let maxPixel = max(self.size.width, self.size.height) * scale
            let downSampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixel
            ] as CFDictionary

            let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

            let newImage = UIImage(cgImage: downSampledImage)
            return newImage
        }
}
