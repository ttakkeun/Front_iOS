//
//  JournalQuestionView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

/// 일지 생성 뷰, 페이지 별로 질문과 답변 출력 뷰
struct JournalQuestionView: View {
    
    @State var selectedAnswer: [String]
    @ObservedObject var viewModel: JournalRegistViewModel
    let question: QuestionDetailData
    let allowMultiSelection: Bool
    
    init(
        selectedAnswer: [String] = .init(),
        viewModel: JournalRegistViewModel,
        question: QuestionDetailData,
        allowMultiSelection: Bool
    ) {
        self.selectedAnswer = selectedAnswer
        self.viewModel = viewModel
        self.question = question
        self.allowMultiSelection = allowMultiSelection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28, content: {
            titleText(question.questionText, question.subtitle)
            
            makeQuestionButton()
                .onAppear {
                    loadSavedQuestion()
                }
            
            Spacer().frame(height: 24)
            
            JournalRegistImages(viewModel: viewModel)
        })
    }
}

extension JournalQuestionView {
    
    func makeQuestionButton() -> VStack<some View> {
        VStack(alignment: .leading, spacing: 16, content: {
            ForEach(question.answer, id: \.answerID) { answer in
                JournalAnswerButton(isSelected: .constant(selectedAnswer.contains(answer.answerText)),
                                    data: answer) {
                    handleSection(answer: answer)
                }
            }
        })
    }
    
    func titleText(_ title: String, _ sub: String) -> VStack<some View> {
        return VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
            
            Text(sub)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
        })
    }
    
    private func loadSavedQuestion() {
        if let savedAnswer = viewModel.selectedAnswerData.answers[question.questionID] {
            selectedAnswer = savedAnswer
        }
    }
    
    private func handleSection(answer: AnswerDetailData) {
        if allowMultiSelection {
            if selectedAnswer.contains(answer.answerText) {
                selectedAnswer.removeAll { $0 == answer.answerText }
            } else {
                selectedAnswer.append(answer.answerText)
            }
        } else {
            selectedAnswer = [answer.answerText]
        }
        
        viewModel.updateAnswer(for: question.questionID, selectedAnswer: selectedAnswer)
    }
}
