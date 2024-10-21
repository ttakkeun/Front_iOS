//
//  JournalQuestionView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/15/24.
//

import SwiftUI

/// 일지 생성 뷰, 페이지 별로 질문과 답변 띄우는 뷰
struct JournalQuestionView: View {
    
    @ObservedObject var viewModel: RegistJournalViewModel
    let question: QuestionDetailData
    let allowMultiSelection: Bool
    let questionIndex: Int
    
    @State var selectionAnswer: [String] = []
    
    /// 질문과 답변 초기화
    /// - Parameters:
    ///   - viewModel: 일지 생성 뷰모델
    ///   - question: API로 받아온 질문과 답변 텍스트
    ///   - allowMultiSelection: 중복 허용
    ///   - questionIndex: 현재 질문의 인덱스
    init(viewModel: RegistJournalViewModel,
         question: QuestionDetailData,
         allowMultiSelection: Bool,
         questionIndex: Int) {
        self.viewModel = viewModel
        self.question = question
        self.allowMultiSelection = allowMultiSelection
        self.questionIndex = questionIndex
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            titleText(question.questionText, question.subtitle)
            
            VStack(spacing: 10, content: {
                ForEach(question.answer, id: \.answerID) { answer in
                    AnswerButton(isSelected: .constant(selectionAnswer.contains(answer.answerText)),
                                 data: answer,
                                 allowMultipleSection: allowMultiSelection
                    ) {
                        handleSelection(answer: answer)
                    }
                }
            })
            .onAppear {
                loadQuestion()
            }
            
            Spacer().frame(height: 10)
            
            DiagnosticImages(viewModel: viewModel)
        })
    }
    
    // MARK: - Function
    /// 일지 등록 타이틀 생성 함수
    /// - Parameters:
    ///   - title: 가장 상단 타이틀
    ///   - sub: 서브 타이틀
    /// - Returns: 뷰 타입 반환
    private func titleText(_ title: String, _ sub: String) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.H2_bold)
                .foregroundStyle(Color.gray_900)
            
            Text(sub)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_400)
        })
    }
    
    /// 질문에 해당하는 답변 조회
    private func loadQuestion() {
        if let savedAnsers = viewModel.inputData.answers[question.questionID] {
            selectionAnswer = savedAnsers
        }
    }
    
    /// 선택한 답변 string 저장
    /// - Parameter answer: 선택한 답변
    private func handleSelection(answer: AnswerDetailData) {
        if allowMultiSelection {
            if selectionAnswer.contains(answer.answerText) {
                selectionAnswer.removeAll { $0 == answer.answerText }
            } else {
                selectionAnswer.append(answer.answerText)
            }
        } else {
            selectionAnswer = [answer.answerText]
        }
        viewModel.updateAnswer(for: question.questionID, selectedAnswer: selectionAnswer)
        print(viewModel.inputData)
    }
}
