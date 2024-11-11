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
        selectCategory
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
                    print("hello")
                }
            }, color: Color.mainPrimary)
        })
    }
    
    // MARK: - 2, 3, 4 page
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
        JournalRegistContents(viewModel: JournalRegistViewModel())
    }
}

