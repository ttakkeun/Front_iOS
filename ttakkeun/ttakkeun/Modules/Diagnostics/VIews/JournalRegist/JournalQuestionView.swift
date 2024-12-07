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
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 28, content: {
                titleText(question.questionText, question.subtitle)
                
                makeQuestionButton()
                    .onAppear {
                        loadSavedQuestion()
                    }
                
                RegistAlbumImageView(viewModel: viewModel, titleText: "사진을 등록해주시면 \n따끈 AI 진단에서 더 정확한 결과를 받을 수 있어요", subTitleText: "최대 5장")
            })
            .frame(alignment: .top)
        }
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
    
    func titleText(_ title: String, _ sub: String) -> some View {
        Group {
            VStack(alignment: .leading, spacing: 10, content: {
                Text(title)
                    .font(.H2_bold)
                    .foregroundStyle(Color.gray900)
                    .truncationMode(.head)
                
                Text(sub)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray400)
            })
        }
        .lineLimit(nil)
        .lineSpacing(2)
        .multilineTextAlignment(.leading)
        
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


struct JournalQuestionView_Preview: PreviewProvider {
    static var previews: some View {
        JournalQuestionView(viewModel: JournalRegistViewModel(petID: 1, container: DIContainer()), question: QuestionDetailData(questionID: 0, questionText: "111", subtitle: "2222", isDupe: true, answer: [AnswerDetailData(answerID: UUID(), answerText: "ggg")]), allowMultiSelection: false)
    }
}
