//
//  RegistDiagnosisPageContents.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

/// 일지 생성 뷰 전환 컨텐츠
struct RegistDiagnosisPageContents: View {
    
    @ObservedObject var viewModel: RegistJournalViewModel
    fileprivate let buttonList: [PartItem] = [.ear, .hair, .eye, .claw , .tooth]
    
    var body: some View {
        currentPageView
    }
    
    /// 현재 페이지 수에대 한 뷰 정의
    @ViewBuilder
    private var currentPageView: some View {
        switch viewModel.currentPage {
        case 1:
            selectCategory
        case 2, 3, 4:
            questionAnswer
        case 5:
            etcTextView
        default:
            EmptyView()
        }
    }
    
    // MARK: - 1 Page(부위 선택)
    
    private var selectCategory: some View {
        VStack(alignment: .center, spacing: 39, content: {
            titleText("기록하고자 하는 \n케어 종류를 선택해주세요", "최대 1가지까지 선택할 수 있어요")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 126), spacing: 14), count: 2), spacing: 6, content: {
                ForEach(buttonList, id: \.self) { partItem in
                    SelectCareButton(partItem: partItem, selectedPart: $viewModel.selectedPart)
                }
            })
            .frame(height: 459)
            
            MainButton(btnText: "다음", width: 339, height: 63, action: {
                if viewModel.selectedPart != nil {
                    Task {
                        viewModel.currentPage += 1
                        await viewModel.getJournalQuestions()
                    }
                }
            }, color: Color.primaryColorMain)
        })
        .frame(width: 339)
    }
    
    // MARK: - 2,3,4 page
    
    @ViewBuilder
    private var questionAnswer: some View {
        if let question = viewModel.currentQuestion {
            VStack(alignment: .center) {
                JournalQuestionView(
                    viewModel: viewModel,
                    question: question,
                    allowMultiSelection: true,
                    questionIndex: viewModel.currentPage - 2)
                
                Spacer()
                
                pageChangeBtn
            }
            .frame(height: 691)
            
        } else {
            ProgressView()
                .frame(width: 100, height: 100)
                .onAppear {
                    viewModel.objectWillChange.send()
                }
        }
    }
    
    /// 페이지 전환 버튼
    @ViewBuilder
    private var pageChangeBtn: some View {
        HStack(alignment: .center, spacing: 9, content: {
            MainButton(btnText: "이전", width: 122, height: 63, action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.currentPage -= 1
                }
            }, color: Color.productCard_Color)
            
            MainButton(btnText: viewModel.currentPage == 5 ? "완료" : "다음", width: 208, height: 63, action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.pageIncrease()
                }
                
                Task {
                    if viewModel.currentPage == 5 {
                        await viewModel.postInputData()
                    }
                }
            }, color: Color.primaryColor_Main)
        })
    }
    
    // MARK: - 완료 페이지
    private var etcTextView: some View {
        VStack(alignment: .center, spacing: 10, content: {
            titleText("기타 특이사항이 있으면 \n알려주세요", "현재 섭취하고 있는 털 영양제나 평소 빗질 빈도 등 추가적인 사항이나 다른 증상들을 입력해주세요")
            TextEditor(text: Binding<String>(
                get: { viewModel.inputData.etc ?? "" },
                set: { viewModel.inputData.etc = $0.isEmpty ? nil : $0 }
            ))
            .customStyleEditor(placeholder: "자세히 적어주세요! 정확한 진단 결과를 받아볼 수 있어요", text: Binding<String>(
                get: { viewModel.inputData.etc ?? "" },
                set: { viewModel.inputData.etc = $0.isEmpty ? nil : $0 }
            ))
            .frame(width: 347, height: 204)
            .onAppear {
                UIApplication.shared.hideKeyboard()
            }
            
            Spacer()
            
            pageChangeBtn
        })
        .frame(height: 691)
        .ignoresSafeArea(.keyboard)
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
        .frame(width: 339, alignment: .leading)
    }
}

// MARK: - Preview

struct RegistDiagnosisPageContents_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            RegistDiagnosisPageContents(viewModel: RegistJournalViewModel(petId: 0))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
        
    }
}
