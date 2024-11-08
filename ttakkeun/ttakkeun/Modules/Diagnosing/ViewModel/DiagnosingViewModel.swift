//
//  DiagnosingViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation

class DiagnosingViewModel: ObservableObject {
    @Published var journalListViewModel: JournalListViewModel = JournalListViewModel()
    @Published var diagnosticViewModel: DiagnosticResultViewModel = DiagnosticResultViewModel()
    
    @Published var diagnosingValue: DiagnosingValue = DiagnosingValue(selectedSegment: .journalList, selectedPartItem: .ear)
}
