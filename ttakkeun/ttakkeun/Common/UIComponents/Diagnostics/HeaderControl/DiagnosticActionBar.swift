//
//  DiagnosingActionView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 진단 탭 상단 액션 바(현재 일지 기록 전용)
struct DiagnosticActionBar: View {
    
    // MARK: - Property
    @Binding var diagnosingValue: DiagnosingValue
    @Bindable var viewModel: JournalListViewModel
    
    // MARK: - Constants
    fileprivate enum DiagnosticActionConstants {
        static let glassSize: CGFloat = 30
        static let selectedAnimation: TimeInterval = 0.7
    }
    
    // MARK: - Body
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
    
    // MARK: - SelectedCount
    /// 일지 선택된 갯수
    private var selectedCount: some View {
        Text("\(viewModel.selectedCnt)장 선택됨")
            .font(.Body3_medium)
            .foregroundStyle(Color.gray900)
            .transition(.opacity)
            .task {
                withAnimation(.easeInOut(duration: DiagnosticActionConstants.selectedAnimation)) {
                    viewModel.isSelectionMode = true
                }
            }
    }
    
    // MARK: - Search
    /// 검색 버튼
    private var searchButton: some View {
        Button(action: {
            viewModel.isCalendarPresented.toggle()
        }, label: {
            Image(.glass)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.gray400)
                .frame(width: DiagnosticActionConstants.glassSize, height: DiagnosticActionConstants.glassSize)
        })
    }
    // MARK: - Search
    
    
    // MARK: - Trassh
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
    
    
    private var trashButton: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.2)) {
                viewModel.deleteJournal(recordIds: viewModel.selectedItem, category: diagnosingValue.selectedPartItem.rawValue)
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

struct DiagnosingActionBar_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosticActionBar(diagnosingValue: .constant(.init(selectedSegment: .journalList, selectedPartItem: .ear)), viewModel: JournalListViewModel(container: .init()))
    }
}
