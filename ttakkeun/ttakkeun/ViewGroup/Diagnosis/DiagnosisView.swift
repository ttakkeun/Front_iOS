//
//  DiagnosisView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

struct DiagnosisView: View {
    @State  var segment: DiagnosisSegment = .diagnosticResults
    @State  var selectedPartItem: PartItem = .hair
    @StateObject var journalListViewModel: JournalListViewModel = JournalListViewModel()
    @EnvironmentObject var petState: PetState
    
    var body: some View {
        DiagnosisHeader(selectedSegment: $segment, selectedPartItem: $selectedPartItem, journalListViewModel: journalListViewModel, petId: petState.petId ?? 0)
    }
}

#Preview {
    DiagnosisView()
        .environmentObject(PetState())
}
