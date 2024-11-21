//
//  JournalRegistContents.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalRegistContents: View {
    
    @ObservedObject var viewModel:  JournalRegistViewModel
    @Environment(\.dismiss) var dismiss
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
        VStack(spacing: 39, content: {
            titleText("기록하고자 하는 \n케어 종류를 선택해주세요", "최대 1가지 선택할 수 있어요")
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(126), spacing: 14), count: 2), spacing: 6, content: {
                ForEach(buttonList, id: \.self) { partItem in
                    SelectCareItemButton(partItemButton: PartItemButton(partItem: partItem, selectedPartItem: $viewModel.selectedPart))
                }
            })
            .frame(height: 459)
            
            MainButton(btnText: "다음", width: 339, height: 63, action: {
                if viewModel.selectedPart != nil {
                    // TODO: - API 받아오기
                    viewModel.currentPage += 1
                }
            }, color: Color.mainPrimary)
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
    }
    
    // MARK: - 2, 3, 4 page
    
    @ViewBuilder
    private var questionAnswer: some View {
        if let question = viewModel.currentQuestion {
            ScrollView(.vertical, content: {
                VStack(alignment: .center, spacing: 40, content: {
                    JournalQuestionView(
                        viewModel: viewModel,
                        question: question,
                        allowMultiSelection: question.isDupe)
                    
                    changePageBtn()
                })
                .frame(height: 691)
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            })
            .frame(maxHeight: .infinity)
        } else {
            VStack {
                Spacer()
                
                ProgressView(label: {
                    LoadingDotsText(text: "질문 데이터를 불러오고 있습니다!! \n잠시만 기다려주세요")
                })
                .controlSize(.large)
                
                Spacer()
            }
        }
    }
    
    private var lastInputEtcTextView: some View {
        VStack(alignment: .center, spacing: 10, content: {
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
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
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
        .frame(maxWidth: 339, alignment: .leading)
    }
    
    func changePageBtn() -> some View {
        HStack(alignment: .center, spacing: 9, content: {
            MainButton(btnText: "이전", width: 122, height: 63, action: {
                viewModel.currentPage -= 1
            }, color: Color.alertNo)
            
            MainButton(btnText: viewModel.currentPage == 5 ? "완료" : "다음", width: 208, height: 63, action: {
                if viewModel.currentPage == 6 {
                    // TODO: - API 보내기
                } else {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.currentPage += 1
                    }
                }
            }, color: Color.mainPrimary)
        })
    }
}

struct JournalRegistContents_Preview: PreviewProvider {
    static var previews: some View {
        JournalRegistContents(viewModel: JournalRegistViewModel(petID: .init(5)))
    }
}

