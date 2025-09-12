//
//  DiagnosingHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

/// 진단 탭 상단 일지/진단 결과 컨트롤러
struct DiagnosticHeader: View {
    
    // MARK: - Property
    @Binding var diagnosingValue: DiagnosingValue
    @Bindable var journalListViewModel: JournalListViewModel
    @Bindable var diagnosticViewModel: DiagnosticResultViewModel
    
    // MARK: - Constants
    fileprivate enum DiagnosticHeaderConstants {
        static let mainVspacing: CGFloat = 16
        static let itemHspacing: CGFloat = 5
        static let animationTimeInterval: TimeInterval = 0.4
        static let textWidth: CGFloat = 30
        static let textHeight: CGFloat = 18
    }
    
    // MARK: - Init
    init(diagnosingValue: Binding<DiagnosingValue>, journalListViewModel: JournalListViewModel, diagnosticViewModel: DiagnosticResultViewModel) {
        self._diagnosingValue = diagnosingValue
        self.journalListViewModel = journalListViewModel
        self.diagnosticViewModel = diagnosticViewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: DiagnosticHeaderConstants.mainVspacing, content: {
            CustomSegment<DiagnosticSegment>(selectedSegment: $diagnosingValue.selectedSegment)
            itemsButton
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .onChange(of: diagnosingValue.selectedSegment) { _, _ in
            swithAction(item: .ear)
        }
    }
    
    /// 파트별 아이템 버튼
    private var itemsButton: some View {
        HStack(alignment: .center, spacing: DiagnosticHeaderConstants.itemHspacing, content: {
            ForEach(PartItem.allCases, id: \.self) { item in
                Button(action: {
                    buttonAction(item: item)
                }, label: {
                    buttonText(item: item)
                })
                .disabled(journalListViewModel.isFetching)
            }
        })
    }
    
    // MARK: - Button
    /// 상단 아이템 버튼 액션
    /// - Parameter item: 버튼 아이템
    private func buttonAction(item: PartItem) {
        withAnimation(.easeInOut(duration: DiagnosticHeaderConstants.animationTimeInterval)) {
            diagnosingValue.selectedPartItem = item
            swithAction(item: item)
        }
    }
    
    /// Switch에 따른 Action
    /// - Parameter item: Part Item
    private func swithAction(item: PartItem) {
        switch diagnosingValue.selectedSegment {
        case .journalList:
            journalListAction(item)
        case .diagnosticResults:
            diagnosticAction(item)
        }
    }
    
    /// 일지 기록 세그먼트 액션
    private func journalListAction(_ item: PartItem) {
        journalListViewModel.recordList.removeAll()
        journalListViewModel.currentPage = .zero
        journalListViewModel.canLoadMore = true
        journalListViewModel.getJournalList(category: item.rawValue, page: .zero)
    }
    
    /// 진단 결과 세그먼트 액션
    private func diagnosticAction(_ item: PartItem) {
        diagnosticViewModel.diagResultListResponse.removeAll()
        diagnosticViewModel.currentPage = .zero
        diagnosticViewModel.canLoadMore = true
        diagnosticViewModel.getDiagResultList(category: item.rawValue, page: .zero)
    }
    
    // MARK: - Text
    private func buttonText(item: PartItem) -> some View {
        Text(item.toKorean())
            .frame(width: 30, height: 18)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .font(diagnosingValue.selectedPartItem == item ? .Body3_bold : .Body3_regular)
            .foregroundStyle(diagnosingValue.selectedPartItem == item ? Color.gray900 : Color.gray600)
            .background {
                if diagnosingValue.selectedPartItem == item {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primarycolor400)
                        .animation(.easeInOut(duration: 0.1), value: diagnosingValue.selectedSegment)
                }
            }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var diagnosingValue: DiagnosingValue = .init(selectedSegment: .journalList, selectedPartItem: .ear)
    
    DiagnosticHeader(diagnosingValue: $diagnosingValue, journalListViewModel: .init(container: DIContainer()), diagnosticViewModel: .init(container: DIContainer()))
}
