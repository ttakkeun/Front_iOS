//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 진단 목록 및 진단결과
struct DiagnosticsView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @Binding var showAlert: Bool
    @Binding var alertText: Text
    @Binding var aiCount: Int
    @Binding var alertType: AlertType
    @Binding var actionYes: () -> Void
    
    @StateObject var journalListViewModel: JournalListViewModel
    @StateObject var diagnosticViewModel: DiagnosticResultViewModel
    
    @State var diagnosingValue: DiagnosingValue = .init(selectedSegment: .journalList, selectedPartItem: .ear)
    
    init(container: DIContainer, showAlert: Binding<Bool>, alertText: Binding<Text>, aiCount: Binding<Int>, alertType: Binding<AlertType>, actionYes: Binding<() -> Void>) {
        self._showAlert = showAlert
        self._alertText = alertText
        self._aiCount = aiCount
        self._alertType = alertType
        self._actionYes = actionYes
        
        self._journalListViewModel = .init(wrappedValue: .init(container: container))
        self._diagnosticViewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12, content: {
            TopStatusBar()
            
            DiagnosingHeader(diagnosingValue: $diagnosingValue, journalListViewModel: journalListViewModel)
            
            DiagnosingActionBar(diagnosingValue: $diagnosingValue, viewModel: journalListViewModel)
            
            changeSegmentView
        })
        .sheet(isPresented: $journalListViewModel.isCalendarPresented, content: {
                DatePicker(
                    "검색 날짜 선택",
                    selection: $journalListViewModel.selectedDate,
                    displayedComponents: [.date]
                )
                .onChange(of: journalListViewModel.selectedDate, {
                    journalListViewModel.isCalendarPresented = false
                })
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.5)])
                .presentationCornerRadius(30)
        })
        .fullScreenCover(isPresented: $journalListViewModel.showFullScreenAI, content: {
            DiagnosingFlowView(viewModel: journalListViewModel)
                .environmentObject(container)
        })
    }
    
    @ViewBuilder
    private var changeSegmentView: some View {
        switch diagnosingValue.selectedSegment {
        case .journalList:
            JournalListView(viewModel: journalListViewModel, showAlert: $showAlert, alertText: $alertText, aiCount: $aiCount, alertType: $alertType, actionYes: $actionYes, selectedPartItem: $diagnosingValue.selectedPartItem)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        case .diagnosticResults:
            DiagnosListView()
        }
    }
}
