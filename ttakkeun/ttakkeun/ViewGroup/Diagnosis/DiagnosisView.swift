//
//  DiagnosisView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

struct DiagnosisView: View {
    @State var segment: DiagnosisSegment = .diagnosticResults
    @StateObject var journalListViewModel: JournalListViewModel
    @StateObject var diagnosticResultViewModel: DiagnosticResultViewModel
    
    init(petId: Int) {
        self._journalListViewModel = StateObject(wrappedValue: JournalListViewModel(petId: petId))
        self._diagnosticResultViewModel = StateObject(wrappedValue: DiagnosticResultViewModel(petId: petId))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            DiagnosisHeader(selectedSegment: $segment, selectedPartItem: $journalListViewModel.selectCategory, journalListViewModel: journalListViewModel)
            
            DiagnosisTopbutton(journalListViewModel: journalListViewModel, diagnosticResultViewModel: diagnosticResultViewModel)
            
            Spacer()
            
            changeView
            
        }
        .ignoresSafeArea(.all)
        
    }
    
    @ViewBuilder
    private var changeView: some View {
        switch segment {
        case .journalList:
            JournalListView(viewModel: journalListViewModel)
        case .diagnosticResults:
            DiagnosisResultView(viewModel: diagnosticResultViewModel)
        }
    }
}

struct DiagnosisView_Prewview: PreviewProvider {
    static var previews: some View {
        DiagnosisView(petId: 0)
    }
}
