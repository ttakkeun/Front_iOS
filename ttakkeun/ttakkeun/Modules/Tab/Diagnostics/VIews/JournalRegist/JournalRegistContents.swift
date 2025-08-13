//
//  JournalRegistContents.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

/// 일지 생성하여 일지 리스트 등록하기 내부 컨텐츠 뷰
struct JournalRegistContents: View {
    
    // MARK: - Property
    @Bindable var viewModel: JournalRegistViewModel
    
    // MARK: - Constants
    fileprivate enum JournalRegistConstants {
        static let titleVspacing: CGFloat = 10
        static let mainBtnHspacing: CGFloat = 9
        static let firstPageVspacing: CGFloat = 28
        static let firstGridHSpacing: CGFloat = 14
        static let firstGridVspacing: CGFloat = 12
        static let spacerHeight: CGFloat = 110
        
        static let titleHeight: CGFloat = 110
        static let editorHeight: CGFloat = 200
        static let gridCount: Int = 2
        static let textMaxcount: Int = 150
        static let mainBtnHeght: CGFloat = 63
        
        static let nextText: String = "다음"
        static let mainBtnText: String = "이전"
        static let completeText: String = "완료"
        static let loadingAnswerText: String = "질문 데이터를 불러오고 있습니다!! \n잠시만 기다려주세요"
        static let noSelectAnswerText: String = "답변이 선택되지 않았습니다."
        static let firstTitle: String = "기록하고자 하는 케어 종류를 선택해주세요"
        static let firstSubTitle: String = "최대 1가지 선택할 수 있어요"
        static let fifthTitle: String = "기타 특이사항이 있으면 알려주세요."
        static let fifthSubTitle: String = "현재 섭취하고 있는 털 영양제나 평소 빗질 빈도 등 추가적인 사항이나 다른 증상들을 입력해주세요"
        static let fifthPlaceholder: String =  "자세히 적어주세요! 정확한 진단 결과를 받아볼 수 있어요"
    }
    
    // MARK: - Body
    var body: some View {
        switch viewModel.currentPage {
        case 1:
            firstPageContents
        case 2, 3, 4:
            questionAnswer
        case 5:
            lastInputEtcTextView
        default:
            EmptyView()
            
        }
    }
    
    // MARK: - 1 Page(부위 선택)
    //
    private var firstPageContents: some View {
        VStack(content: {
            titleText(title: JournalRegistConstants.firstTitle, subTitle: JournalRegistConstants.firstSubTitle)
            Spacer().frame(maxHeight: JournalRegistConstants.firstPageVspacing)
            selectCategory
            Spacer()
        })
        .safeAreaInset(edge: .bottom, content: {
            MainButton(btnText: JournalRegistConstants.nextText, height: JournalRegistConstants.mainBtnHeght, action: {
                if viewModel.selectedPart != nil {
                    viewModel.currentPage += 1
                    viewModel.getAnswerList()
                }
            }, color: Color.mainPrimary)
        })
    }
    
    /// 첫 번째 페이지 카테고리 선택
    @ViewBuilder
    private var selectCategory: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: JournalRegistConstants.firstGridHSpacing), count: JournalRegistConstants.gridCount)
        
        LazyVGrid(columns: columns, spacing: JournalRegistConstants.firstGridVspacing, content: {
            ForEach(viewModel.buttonList, id: \.self) { partItem in
                SelectCareItemButton(partItemButton: PartItemButton(partItem: partItem, selectedPartItem: $viewModel.selectedPart))
            }
        })
    }
    
    // MARK: - 2, 3, 4 page
    @ViewBuilder
    private var questionAnswer: some View {
        if !viewModel.questionIsLoading {
            if let question = viewModel.currentQuestion {
                ScrollView(.vertical, content: {
                    VStack(alignment: .center, content: {
                        JournalQuestionView(
                            viewModel: viewModel,
                            question: question,
                            allowMultiSelection: question.isDupe)
                        
                        Spacer().frame(height: JournalRegistConstants.spacerHeight)

                    })
                })
                .id(question.questionID)
                .safeAreaInset(edge: .bottom, content: {
                    
                    changePageBtn()
                })
                .contentMargins(.top, UIConstants.topScrollPadding, for: .scrollContent)
            }
        } else {
            LoadingProgress(text: JournalRegistConstants.loadingAnswerText)
        }
    }
    
    // MARK: - 5 page
    /// 마지막 페이지
    private var lastInputEtcTextView: some View {
        VStack(alignment: .leading, spacing: JournalRegistConstants.titleVspacing, content: {
            titleText(title: JournalRegistConstants.fifthTitle, subTitle: JournalRegistConstants.fifthSubTitle)
            
            TextEditor(text: lastInputBinding())
                .customStyleEditor(
                    text: lastInputBinding(),
                    placeholder: JournalRegistConstants.fifthPlaceholder,
                    maxTextCount: JournalRegistConstants.textMaxcount)
                .frame(height: JournalRegistConstants.editorHeight)
            
            Spacer()
            
            changePageBtn()
        })
    }
    
    private func lastInputBinding() -> Binding<String> {
        return Binding<String>(
            get: { viewModel.selectedAnswerData.etc ?? "" },
            set: { viewModel.selectedAnswerData.etc = $0.isEmpty ? nil : $0 }
        )
    }
}

extension JournalRegistContents {
    /// 상단 가이드 타이틀 및 서브 타이틀
    /// - Parameters:
    ///   - title: 타이틀 텍스트
    ///   - subTitle: 서브 타이틀 텍스트
    /// - Returns: 뷰 반환
    func titleText(title: String, subTitle: String) -> some View {
        VStack(alignment: .leading, spacing: JournalRegistConstants.titleVspacing, content: {
            Text(title)
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
            
            Text(subTitle)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
        })
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(maxHeight: JournalRegistConstants.titleHeight)
    }
    
    /// 2 ~ 5 페이지 뷰 이전 다음 버튼
    /// - Returns: 버튼 뷰 반환
    func changePageBtn() -> some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
                .frame(height: UIConstants.safeBottom)
            
            HStack(alignment: .center, spacing: JournalRegistConstants.mainBtnHspacing, content: {
                MainButton(btnText: JournalRegistConstants.mainBtnText, height: JournalRegistConstants.mainBtnHeght, action: {
                    if viewModel.currentPage == 2 {
                        viewModel.getQuestions = nil
                        viewModel.currentPage -= 1
                    } else {
                        viewModel.currentPage -= 1
                    }
                }, color: Color.alertNo)
                
                MainButton(btnText: viewModel.currentPage == 5 ? JournalRegistConstants.completeText : viewModel.isNextEnabled ? JournalRegistConstants.nextText : JournalRegistConstants.noSelectAnswerText, height: JournalRegistConstants.mainBtnHeght, action: {
                    mainButtonAction()
                }, color: Color.mainPrimary)
                .disabled(!viewModel.isNextEnabled)
            })
        }
    }
    
    /// 이전 및 다음 버튼 액션
    /// - Returns: 액션 반환
    private func mainButtonAction() -> Void {
        if viewModel.currentPage < 5 {
            viewModel.currentPage += 1
            viewModel.isNextEnabled = false
        } else {
            viewModel.makeJournal()
        }
    }
}
