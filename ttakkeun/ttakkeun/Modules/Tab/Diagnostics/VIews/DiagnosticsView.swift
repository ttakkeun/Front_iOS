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
        static let calendarHeight: CGFloat = 430
        static let cornerRadius: CGFloat = 30
        static let datePickerText: String = "검색 날짜 선택"
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
        .customAlert(alert: alert)
        .fullScreenCover(isPresented: $journalListViewModel.showFullScreenAI, content: {
            diagnosisFlowView
        })
        .sheet(isPresented: $journalListViewModel.isCalendarPresented, content: {
            datePicker
        })
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
                .environment(alert)
        case .diagnosticResults:
            DiagnosticTowerListView(viewModel: diagnosticViewModel, selectedPartItem: $diagnosingValue.selectedPartItem)
        }
    }
    
    // MARK: - DiagnosisFlowView
    /// 진단 전체 흐름 뷰
    @ViewBuilder
    private var diagnosisFlowView: some View {
        if journalListViewModel.isShowMakeDiagLoading {
            DiagnosticLoadingView()
        } else {
            DiagnosticResultView(viewModel: diagnosticViewModel, showFullScreenAI: $journalListViewModel.showFullScreenAI, diagId: journalListViewModel.diagResultResponse?.result_id ?? 0)
        }
    }
    
    // MARK: - DatePicker
    /// 달력 피커
    private var datePicker: some View {
        DatePicker(
            DiagnoticsConstants.datePickerText,
            selection: $journalListViewModel.selectedDate,
            displayedComponents: [.date]
        )
        .onChange(of: journalListViewModel.selectedDate, {
            journalListViewModel.isCalendarPresented = false
            journalListViewModel.searchGetJournal(category: diagnosingValue.selectedPartItem.rawValue, date: journalListViewModel.selectedDate.formattedForAPI())
        })
        .datePickerStyle(GraphicalDatePickerStyle())
        .presentationDragIndicator(.visible)
        .presentationDetents([.height(DiagnoticsConstants.calendarHeight)])
        .presentationCornerRadius(DiagnoticsConstants.cornerRadius)
    }
}

#Preview {
    DiagnosticsView(container: DIContainer())
        .environmentObject(DIContainer())
        .environment(AlertStateModel())
}
