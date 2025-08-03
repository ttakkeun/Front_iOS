//
//  JournalQuestionView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

/// 일지 생성 뷰, 페이지 별로 질문과 답변 출력 뷰(2,3,4 페이지 활용)
struct JournalQuestionView: View {
    
    // MARK: - Property
    @Bindable var viewModel: JournalRegistViewModel
    let question: QuestionDetailData
    let allowMultiSelection: Bool
    
    // MARK: - Constants
    fileprivate enum JournalQuestionConstants {
        static let questionVspacing: CGFloat = 16
        static let contentsVspacing: CGFloat = 24
        static let titleVspacing: CGFloat = 10
        static let lineSpacing: Double = 2
        static let maxCount: Int = 5
        
        static let albumText: String = "사진을 등록해주시면 \n따끈 AI 진단에서 더 정확한 결과를 받을 수 있어요"
        static let subTitle: String = "최대 5장"
    }
    
    // MARK: - Init
    init(
        viewModel: JournalRegistViewModel,
        question: QuestionDetailData,
        allowMultiSelection: Bool
    ) {
        self.viewModel = viewModel
        self.question = question
        self.allowMultiSelection = allowMultiSelection
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: JournalQuestionConstants.contentsVspacing, content: {
            titleText(question.questionText, question.subtitle)
            middleContents
            RegistAlbumImageView(viewModel: viewModel, titleText: JournalQuestionConstants.albumText, subTitleText: JournalQuestionConstants.subTitle)
        })
        .photosPicker(isPresented: $viewModel.isImagePickerPresented, selection: $viewModel.imageItems, maxSelectionCount: JournalQuestionConstants.maxCount, matching: .images)
        .onChange(of: viewModel.imageItems, { old, new in
            viewModel.convertPickerItemsToUIImages(items: new)
        })
        .task {
            viewModel.isNextEnabled = viewModel.selectedAnswerData.answers[question.questionID]?.isEmpty == false
        }
    }
    
    /// 중간 질문 생성 컨텐츠
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: JournalQuestionConstants.questionVspacing, content: {
            ForEach(question.answer, id: \.answerID) { answer in
                JournalAnswerButton(
                    isSelected: isSelectedAction(answer: answer),
                    data: answer
                )
            }
        })
    }
}

extension JournalQuestionView {
    private func isSelectedAction(answer: AnswerDetailData) -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                viewModel.selectedAnswerData.answers[question.questionID]?.contains(answer.answerText) ?? false
            },
            set: { isSelected in
                if allowMultiSelection {
                    allowMultAction(answer: answer, isSelected: isSelected)
                } else {
                    viewModel.selectedAnswerData.answers[question.questionID] = isSelected ? [answer.answerText] : []
                }
                
                viewModel.isNextEnabled = viewModel.selectedAnswerData.answers[question.questionID]?.isEmpty == false
            }
        )
    }
    
    /// 전체 선택 허용 메뉴일 경우 액션 처리
    /// - Parameters:
    ///   - answer: 질문
    ///   - isSelected: 선택되었는지 유무
    /// - Returns: 액션 바놘
    private func allowMultAction(answer: AnswerDetailData, isSelected: Bool) -> Void {
        if isSelected {
            if viewModel.selectedAnswerData.answers[question.questionID] == nil {
                viewModel.selectedAnswerData.answers[question.questionID] = []
            }
            viewModel.selectedAnswerData.answers[question.questionID]?.append(answer.answerText)
        } else {
            viewModel.selectedAnswerData.answers[question.questionID]?.removeAll { $0 == answer.answerText }
        }
    }
    
    /// 질문 타이틀
    /// - Parameters:
    ///   - title: 질문 타이틀
    ///   - sub: 질문 서브 타이틀
    /// - Returns: 상단 티이틀 뷰 반환
    func titleText(_ title: String, _ sub: String) -> some View {
        Group {
            VStack(alignment: .leading, spacing: JournalQuestionConstants.titleVspacing, content: {
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
        .lineSpacing(JournalQuestionConstants.lineSpacing)
        .multilineTextAlignment(.leading)
        
    }
}

#Preview {
    JournalQuestionView(viewModel: .init(container: DIContainer()), question: .init(questionID: 1, questionText: "sss", subtitle: "1", isDupe: false, answer: [
        .init(answerText: "111")
    ]), allowMultiSelection: false)
}
