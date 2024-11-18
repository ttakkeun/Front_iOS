//
//  JournalRegistViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import Foundation
import SwiftUI

class JournalRegistViewModel: ObservableObject {
    
    @Published var currentPage: Int = 1
    @Published var selectedPart: PartItem?
    
    @Published var getQuestions: JournalQuestionResponse?
    @Published var selectedAnswerData: SelectedAnswerData
    
    @Published var isImagePickerPresented: Bool = false
    @Published var questionImages: [Int: [UIImage]] = [:]
    
    init(petID: Int) {
        selectedAnswerData = .init(petId: petID)
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
            questionImages[questionId, default: []].append(images)
        }
    }
    
    func removeImage(at index: Int) {
        guard let questionID = currentQuestion?.questionID else { return }
        questionImages[questionID]?.remove(at: index)
    }
    
    func showImagePicker() {
        isImagePickerPresented = true
    }
    
    func getImages() -> [UIImage] {
        guard let questionID = currentQuestion?.questionID else { return [] }
        return questionImages[questionID] ?? []
    }
}
