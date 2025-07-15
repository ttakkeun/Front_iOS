//
//  JournalRegistViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//
import SwiftUI
import UIKit
import Combine
import CombineMoya
import Moya
import PhotosUI

@Observable
class JournalRegistViewModel {

    var currentPage: Int = 1
    
    // MARK: - Property
    var selectedPart: PartItem?
    let buttonList: [PartItem] = [.ear, .hair, .eye, .claw , .teeth]
    var getQuestions: JournalQuestionResponse?
    var selectedAnswerData: SelectedAnswerRequest
    var questionImages: [Int: [UIImage]] = [:]
    var imageItems: [PhotosPickerItem] = []
    
    var currentQuestion: QuestionDetailData? {
        guard let getQuestion = getQuestions, currentPage - 1 <= getQuestion.question.count else { return nil }
        return getQuestion.question[currentPage - 2]
    }
    
    var selectedImageCount: Int {
        guard let questionID = currentQuestion?.questionID else { return 0 }
        return questionImages[questionID]?.count ?? 0
    }
    
    // MARK: - StateProperty
    var isNextEnabled: Bool = false
    var isImagePickerPresented: Bool = false
    var questionIsLoading: Bool = false
    var makeJournalsLoading: Bool = false
    var isNextEnalbes:Bool = false
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        selectedAnswerData = .init(petId: UserDefaults.standard.integer(forKey: AppStorageKey.petId))
        self.container = container
    }
    
    // MARK: - Method
    func updateAnswer(for questionID: Int, selectedAnswer: [String]) {
        selectedAnswerData.answers[questionID] = selectedAnswer
    }
    
    func convertPickerItemsToUIImages(items: [PhotosPickerItem]) {
        var loadedImages: [UIImage] = []
        let dispatchGroup = DispatchGroup()

        for item in items {
            dispatchGroup.enter()
            item.loadTransferable(type: Data.self) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        loadedImages.append(image)
                    }
                case .failure(let error):
                    print("Failed to load image: \(error.localizedDescription)")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.addImage(loadedImages)
        }
    }
}

extension JournalRegistViewModel: PhotoPickerHandle {
    func addImage(_ images: [UIImage]) {
        // guard let questionId = currentQuestion?.questionID else { return }
        let questionId = 1

        DispatchQueue.global(qos: .userInitiated).async {
            let originalImages = images

            DispatchQueue.main.async {
                self.questionImages[questionId] = Array(originalImages.prefix(5))
            }
        }
    }
    
    func removeImage(at index: Int) {
//        guard let questionID = currentQuestion?.questionID else { return }
        let questionID = 1
        questionImages[questionID]?.remove(at: index)
        
        if imageItems.indices.contains(index) {
            imageItems.remove(at: index)
        }
    }
    
    func getImages() -> [UIImage] {
//        guard let questionID = currentQuestion?.questionID else { return [] }
        let questionID = 1
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
