//
//  RegistDiagnosisPageContents.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

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
            firstPage
        default:
            EmptyView()
        }
    }
    
    // MARK: - 1 Page(부위 선택)
    
    /// 부위 선택
    //TODO: - 서브 타이틀 수정할 것
    private var firstPage: some View {
        VStack(alignment: .center, spacing: 39, content: {
            titleText("기록하고자 하는 \n케어 종류를 선택해주세요", "최대 1가지까지 선택할 수 있어요")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 126), spacing: 14), count: 2), spacing: 6, content: {
                ForEach(buttonList, id: \.self) { partItem in
                    SelctCareButton(partItem: partItem, selectedPart: $viewModel.selectedPart)
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
    
    // MARK: - 2 page(첫 번째 질문)
    
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
                .foregroundStyle(Color.gray_600)
        })
        .frame(width: 339, height: 100, alignment: .leading)
    }
    
}

// MARK: - Preview

struct RegistDiagnosisPageContents_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            RegistDiagnosisFlowView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
        
    }
}
