//
//  JournalRegistContents.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalRegistContents: View {
    
    @StateObject var viewModel: JournalRegistViewModel
    fileprivate let buttonList: [PartItem] = [.ear, .hair, .eye, .claw , .teeth]
    
    var body: some View {
        switch viewModel.currentPage {
        case 1:
            selectCategory
        case 2, 3, 4:
            questionAnswer
        case 5:
            lastInputEtcTextView
        default:
            EmptyView()
        }
    }
    
    // MARK: - 1 Page(부위 선택)
    
    private var selectCategory: some View {
        VStack(content: {
            titleText("기록하고자 하는 \n케어 종류를 선택해주세요", "최대 1가지 선택할 수 있어요")
            
            Spacer().frame(height: 38)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(126), spacing: 14), count: 2), spacing: 6, content: {
                ForEach(buttonList, id: \.self) { partItem in
                    SelectCareItemButton(partItemButton: PartItemButton(partItem: partItem, selectedPartItem: $viewModel.selectedPart))
                }
            })
            .frame(height: 459)
            
            Spacer().frame(height: 39)
            
            MainButton(btnText: "다음", width: 339, height: 63, action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if viewModel.selectedPart != nil {
                        viewModel.currentPage += 1
                        viewModel.getAnswerList()
                    }
                }
            }, color: Color.mainPrimary)
        })
        .frame(width: 353, height: 691)
    }
    
    // MARK: - 2, 3, 4 page
    
    @ViewBuilder
    private var questionAnswer: some View {
        if !viewModel.questionIsLoading {
            if let question = viewModel.currentQuestion {
                VStack(alignment: .center, content: {
                    JournalQuestionView(
                        viewModel: viewModel,
                        question: question,
                        allowMultiSelection: question.isDupe)
                    
                    Spacer()
                    
                    changePageBtn()
                })
                .frame(width: 353, height: 691)
                
            }
        } else {
            VStack {
                Spacer()
                
                ProgressView(label: {
                    LoadingDotsText(text: "질문 데이터를 불러오고 있습니다!! \n잠시만 기다려주세요")
                })
                .controlSize(.large)
                
                Spacer()
            }
            .frame(width: 353, height: 691)
        }
    }
    
    private var lastInputEtcTextView: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            titleText("기타 특이사항이 있으면 \n알려주세요", "현재 섭취하고 있는 털 영양제나 평소 빗질 빈도 등 추가적인 사항이나 다른 증상들을 입력해주세요")
            
            TextEditor(text: Binding<String>(
                get: { viewModel.selectedAnswerData.etc ?? "" },
                set: { viewModel.selectedAnswerData.etc = $0.isEmpty ? nil : $0 }
            ))
            .customStyleEditor(
                text: Binding<String>(
                    get: { viewModel.selectedAnswerData.etc ?? "" },
                    set: { viewModel.selectedAnswerData.etc = $0.isEmpty ? nil : $0 }
                ),
                placeholder: "자세히 적어주세요! 정확한 진단 결과를 받아볼 수 있어요",
                maxTextCount: 150)
            .frame(width: 347, height: 204)
            .onAppear {
                UIApplication.shared.hideKeyboard()
            }
            Spacer()
            
            changePageBtn()
        })
        .frame(maxWidth: 353, maxHeight: 691, alignment: .top)
        .ignoresSafeArea(.keyboard)
    }
}

extension JournalRegistContents {
    func titleText(_ title: String, _ sub: String) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
            
            Text(sub)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
        })
        .frame(maxWidth: 339, alignment: .topLeading)
    }
    
    func changePageBtn() -> some View {
        HStack(alignment: .center, spacing: 9, content: {
            MainButton(btnText: "이전", width: 122, height: 63, action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if viewModel.currentPage == 2 {
                        viewModel.getQuestions = nil
                        viewModel.currentPage -= 1
                    } else {
                        viewModel.currentPage -= 1
                    }
                }
            }, color: Color.alertNo)
            
            MainButton(btnText: viewModel.currentPage == 5 ? "완료" : "다음", width: 208, height: 63, action: {
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    if viewModel.currentPage < 5 {
                        viewModel.currentPage += 1
                        viewModel.isNextEnabled = false
                    } else {
                    viewModel.makeJournal()
                    }
                        
                }
            }, color: Color.mainPrimary)
            .disabled(!viewModel.isNextEnabled)
            })
    }
}
