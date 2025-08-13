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
        static let rightButtonSpacing: CGFloat = 7
        
        static let trashPadding: CGFloat = 2
        static let buttonVerticalPadding: CGFloat = 8
        static let buttonHorizonPadding: CGFloat = 21
        
        static let cornerRadius: CGFloat = 20
        
        static let glassSize: CGFloat = 30
        static let selectedAnimation: TimeInterval = 0.7
        static let trashAnimationTime: TimeInterval = 0.2
        static let cancelText: String = "취소"
        static let selectText: String = "선택"
    }
    
    // MARK: - Body
    var body: some View {
        HStack(content: {
            if viewModel.isSelectionMode {
                leftSelectedCount
            }
            Spacer()
            rightButton
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    // MARK: - Right
    /// 오른쪽 검색 모드 버튼
    private var rightButton: some View {
        HStack(spacing: DiagnosticActionConstants.rightButtonSpacing, content: {
            if !viewModel.isSelectionMode {
                searchButton
            } else {
                trashButton
            }
            cancelOrSelectButton
        })
    }
    
    // MARK: - Left
    /// 일지 선택된 갯수
    private var leftSelectedCount: some View {
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
    
    // MARK: - Trash
    /// 쓰레기 버튼
    private var trashButton: some View {
        Button(action: {
            withAnimation(.easeIn(duration: DiagnosticActionConstants.trashAnimationTime)) {
                viewModel.deleteJournal(recordIds: viewModel.selectedItem, category: diagnosingValue.selectedPartItem.rawValue)
            }
        }, label: {
            Image(.trash)
                .padding([.vertical, .horizontal], DiagnosticActionConstants.trashAnimationTime)
                .background {
                    Circle()
                        .fill(Color.checkBg)
                }
        })
    }
    
    /// 취소 선택 버튼
    private var cancelOrSelectButton: some View {
        Button(action: {
            cancelSelectButton()
        }, label: {
            Text(viewModel.isSelectionMode ? DiagnosticActionConstants.cancelText : DiagnosticActionConstants.selectText)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .padding(.vertical, DiagnosticActionConstants.buttonVerticalPadding)
                .padding(.horizontal, DiagnosticActionConstants.buttonHorizonPadding)
                .background {
                    RoundedRectangle(cornerRadius: DiagnosticActionConstants.cornerRadius)
                        .fill(Color.checkBg)
                }
        })
    }
    
    /// 취소 선택 버튼 액션
    private func cancelSelectButton() {
        if !viewModel.isSelectionMode {
            withAnimation(.easeInOut) {
                viewModel.isSelectionMode = true
            }
        } else {
            withAnimation(.easeInOut) {
                viewModel.isSelectionMode = false
                viewModel.selectedItem.removeAll()
                viewModel.selectedCnt = .zero
            }
        }
    }
}

#Preview {
    DiagnosticActionBar(diagnosingValue: .constant(.init(selectedSegment: .journalList, selectedPartItem: .ear)), viewModel: JournalListViewModel(container: .init()))
}
