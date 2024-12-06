//
//  DiagnosingActionView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

struct DiagnosingActionBar: View {
    
    @ObservedObject var viewModel: JournalListViewModel
    
    var body: some View {
        HStack(content: {
            
            if viewModel.isSelectionMode {
                selectedCount
                
                Spacer()
            } else {
                Spacer()
            }
            
            rightAction
        })
        .frame(maxWidth: 340)
        .padding(.top, 6)
    }
    
    private var rightAction: some View {
        HStack(spacing: 7, content: {
            if !viewModel.isSelectionMode {
                searchButton
            } else {
                trashButton
            }
            
            cancelOrSelectButton
        })
        .frame(maxWidth: 102)
    }
    
    
    private var selectedCount: some View {
        Text("\(viewModel.selectedCnt)장 선택됨")
                .frame(maxWidth: 120, alignment: .leading)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
                .transition(.opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        viewModel.isSelectionMode = true
                    }
                }
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
    
    private var cancelOrSelectButton: some View {
        Button(action: {
            if !viewModel.isSelectionMode {
                withAnimation(.easeInOut) {
                    viewModel.isSelectionMode = true
                    print(viewModel.isSelectionMode)
                }
            } else {
                withAnimation(.easeInOut) {
                    viewModel.isSelectionMode = false
                    viewModel.selectedItem.removeAll()
                    viewModel.selectedCnt = 0
                }
            }
        }, label: {
            Text(viewModel.isSelectionMode ? "취소" : "선택")
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
