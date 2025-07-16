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
    
    // MARK: - Init
    init(container: DIContainer) {
        self.journalListViewModel = .init(container: container)
        self.diagnosticViewModel = .init(container: container)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12, content: {
            TopStatusBar()
                .environmentObject(container)
            
            DiagnosticHeader(diagnosingValue: $diagnosingValue, journalListViewModel: journalListViewModel, diagnosticViewModel: diagnosticViewModel)
            
            if diagnosingValue.selectedSegment == .journalList {
                DiagnosticActionBar(diagnosingValue: $diagnosingValue, viewModel: journalListViewModel)
            }
            
            changeSegmentView
        })
        .background(Color.scheduleBg)
        .sheet(isPresented: $journalListViewModel.isCalendarPresented, content: {
                DatePicker(
                    "검색 날짜 선택",
                    selection: $journalListViewModel.selectedDate,
                    displayedComponents: [.date]
                )
                .onChange(of: journalListViewModel.selectedDate, {
                    journalListViewModel.isCalendarPresented = false
                    journalListViewModel.searchGetJournal(category: diagnosingValue.selectedPartItem.rawValue, date: DataFormatter.shared.formatDateForAPI(journalListViewModel.selectedDate))
                })
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.5)])
                .presentationCornerRadius(30)
        })
//        .fullScreenCover(isPresented: $journalListViewModel.showFullScreenAI, content: {
//            DiagnosingFlowView(viewModel: journalListViewModel)
//                .environmentObject(container)
//        })
    }
    
    // FIXME: - Tab
    @ViewBuilder
    private var changeSegmentView: some View {
        switch diagnosingValue.selectedSegment {
        case .journalList:
            Text("11")
//            JournalListView(viewModel: journalListViewModel, showAlert: $showAlert, alertText: $alertText, aiCount: $aiCount, alertType: $alertType, actionYes: $actionYes, selectedPartItem: $diagnosingValue.selectedPartItem)
//                .environmentObject(container)
//                .environmentObject(appFlowViewModel)
        case .diagnosticResults:
//            DiagnosListView(viewModel: diagnosticViewModel, selectedPartItem: $diagnosingValue.selectedPartItem)
            Text("11")
        }
    }
}
