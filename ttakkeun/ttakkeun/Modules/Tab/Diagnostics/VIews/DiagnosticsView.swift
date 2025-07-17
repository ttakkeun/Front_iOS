//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 진단 목록 및 진단결과
struct DiagnosticsView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @Environment(AlertStateModel.self) var alert
    @State var journalListViewModel: JournalListViewModel
    @State var diagnosticViewModel: DiagnosticResultViewModel
    @State var diagnosingValue: DiagnosingValue = .init(selectedSegment: .journalList, selectedPartItem: .ear)
    
    // MARK: - Constants
    fileprivate enum DiagnoticsConstants {
        static let mainVspacing: CGFloat = 12
        static let topVspacing: CGFloat = 18
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.journalListViewModel = .init(container: container)
        self.diagnosticViewModel = .init(container: container)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DiagnoticsConstants.mainVspacing, content: {
            TopStatusBar()
                .environmentObject(container)
                .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
            topContents
            middleContents
        })
        .background(Color.scheduleBg)
        //        .sheet(isPresented: $journalListViewModel.isCalendarPresented, content: {
        //                DatePicker(
        //                    "검색 날짜 선택",
        //                    selection: $journalListViewModel.selectedDate,
        //                    displayedComponents: [.date]
        //                )
        //                .onChange(of: journalListViewModel.selectedDate, {
        //                    journalListViewModel.isCalendarPresented = false
        //                    journalListViewModel.searchGetJournal(category: diagnosingValue.selectedPartItem.rawValue, date: DataFormatter.shared.formatDateForAPI(journalListViewModel.selectedDate))
        //                })
        //                .datePickerStyle(GraphicalDatePickerStyle())
        //                .presentationDragIndicator(.visible)
        //                .presentationDetents([.fraction(0.5)])
        //                .presentationCornerRadius(30)
        //        })
        //        .fullScreenCover(isPresented: $journalListViewModel.showFullScreenAI, content: {
        //            DiagnosingFlowView(viewModel: journalListViewModel)
        //                .environmentObject(container)
        //        })
    }
    
    // MARK: - TopContents
    /// 상단 액션 컨트롤러 버튼
    private var topContents: some View {
        VStack(alignment: .leading, spacing: DiagnoticsConstants.topVspacing, content: {
            DiagnosticHeader(diagnosingValue: $diagnosingValue, journalListViewModel: journalListViewModel, diagnosticViewModel: diagnosticViewModel)
            if diagnosingValue.selectedSegment == .journalList {
                DiagnosticActionBar(diagnosingValue: $diagnosingValue, viewModel: journalListViewModel)
            }
        })
    }
    
    // MARK: - MiddleContents
    @ViewBuilder
    private var middleContents: some View {
        switch diagnosingValue.selectedSegment {
        case .journalList:
            JournalListView(viewModel: journalListViewModel, selectedPartItem: $diagnosingValue.selectedPartItem)
        case .diagnosticResults:
            DiagnosticTowerListView(viewModel: diagnosticViewModel, selectedPartItem: $diagnosingValue.selectedPartItem)
        }
    }
    
    // MARK: - FullScreenCover
    
}

#Preview {
    DiagnosticsView(container: DIContainer())
        .environmentObject(DIContainer())
        .environment(AlertStateModel())
}
