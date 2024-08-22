//
//  DiagnosisView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

struct DiagnosisView: View {
    @State var segment: DiagnosisSegment = .journalList
    @StateObject var journalListViewModel: JournalListViewModel
    @StateObject var diagnosticResultViewModel: DiagnosticResultViewModel
    @EnvironmentObject var petState: PetState
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var tabManager: TabBarVisibilityManager
    
    init(petId: Int, container: DIContainer) {
        self._journalListViewModel = StateObject(wrappedValue: JournalListViewModel(petId: petId, container: container))
        self._diagnosticResultViewModel = StateObject(wrappedValue: DiagnosticResultViewModel(petId: petId))
    }
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            VStack(spacing: 10) {
                DiagnosisHeader(selectedSegment: $segment, selectedPartItem: $journalListViewModel.selectCategory, journalListViewModel: journalListViewModel)
                
                DiagnosisTopbutton(journalListViewModel: journalListViewModel, diagnosticResultViewModel: diagnosticResultViewModel)
                
                Spacer()
                
                changeView
                
            }
            .ignoresSafeArea(.all)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
                    .environmentObject(tabManager)
            }
        }
    }
    
    @ViewBuilder
    private var changeView: some View {
        switch segment {
        case .journalList:
            JournalListView(viewModel: journalListViewModel)
                .onAppear {
                    if journalListViewModel.journalListData == nil {
                        journalListViewModel.getJournalList(page: 0)
                    }
                    Task {
                        await diagnosticResultViewModel.getDiagnosticPoint()
                    }
                }
        case .diagnosticResults:
            DiagnosisResultView(viewModel: diagnosticResultViewModel)
        }
    }
}
