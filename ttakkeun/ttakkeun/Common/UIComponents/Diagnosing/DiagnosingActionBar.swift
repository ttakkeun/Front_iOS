//
//  DiagnosingActionView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

struct DiagnosingActionBar: View {
    
    @ObservedObject var viewModel: DiagnosingViewModel
    
    var body: some View {
        cancelButton
    }
    
    
    private var selectedCount: some View {
            Text("\(viewModel.journalListViewModel.selectedCnt)장 선택됨")
                .frame(maxWidth: 120)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
    }
    
    private var searchButton: some View {
        Button(action: {
            print("검색 버튼")
        }, label: {
            Icon.glass.image
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.gray400)
                .frame(width: 30, height: 30)
        })
    }
    
    private var trashButton: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.2)) {
                // TODO: - 삭제 버튼 액션 필요
                print("쓰레기 버튼")
            }
        }, label: {
            Icon.trash.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding([.vertical, .horizontal], 2)
                .background {
                    Circle()
                        .fill(Color.checkBg)
                }
        })
    }
    
    private var cancelButton: some View {
        Button(action: {
            if !viewModel.journalListViewModel.isSelectionMode {
                withAnimation(.easeInOut) {
                    viewModel.journalListViewModel.isSelectionMode = true
                }
            } else {
                withAnimation(.easeInOut) {
                    viewModel.journalListViewModel.isSelectionMode = false
                    
                    // TODO: - 취소 버튼 액션 필요
                }
            }
        }, label: {
            Text(viewModel.journalListViewModel.isSelectionMode ? "취소" : "선택")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .frame(width: 21, height: 16)
                .padding(.vertical, 8)
                .padding(.horizontal, 21)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.checkBg)
                }
        })
    }
}

struct DiagnosingActionBar_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosingActionBar(viewModel: DiagnosingViewModel())
    }
}
