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
    
    @StateObject var journalListViewModel: JournalListViewModel
    @StateObject var diagnosticViewModel: DiagnosticResultViewModel = .init()
    
    @State var diagnosingValue: DiagnosingValue = .init(selectedSegment: .journalList, selectedPartItem: .ear)
    
    init(container: DIContainer, showAlert: Binding<Bool>, alertText: Binding<Text>, aiCount: Binding<Int>, alertType: Binding<AlertType>) {
        self._showAlert = showAlert
        self._alertText = alertText
        self._aiCount = aiCount
        self._alertType = alertType
        
        self._journalListViewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12, content: {
            TopStatusBar()
            
            DiagnosingHeader(diagnosingValue: $diagnosingValue, journalListViewModel: journalListViewModel)
            
            DiagnosingActionBar(diagnosingValue: $diagnosingValue, viewModel: journalListViewModel)
            
            changeSegmentView
        })
        .sheet(isPresented: $journalListViewModel.isCalendarPresented, content: {
            Form {
                DatePicker(
                    "검색 날짜 선택",
                    selection: $journalListViewModel.selectedDate,
                    displayedComponents: [.date]
                )
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.5)])
            .datePickerStyle(GraphicalDatePickerStyle())
            .onChange(of: journalListViewModel.selectedDate, {
                journalListViewModel.isCalendarPresented = false
            })
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
        })
    }
    
    @ViewBuilder
    private var changeSegmentView: some View {
        switch diagnosingValue.selectedSegment {
        case .journalList:
            JournalListView(viewModel: journalListViewModel, showAlert: $showAlert, alertText: $alertText, aiCount: $aiCount, alertType: $alertType, selectedPartItem: $diagnosingValue.selectedPartItem)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        case .diagnosticResults:
            DiagnosListView()
        }
    }
}
