//
//  DiagnosingHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

struct DiagnosingValue {
    var selectedSegment: DiagnosingSegment
    var selectedPartItem: PartItem
}

struct DiagnosingHeader: View {
    
    @Binding var diagnosingValue: DiagnosingValue
    @ObservedObject var journalListViewModel: JournalListViewModel
    @ObservedObject var diagnosticViewModel: DiagnosticResultViewModel
    
    init(diagnosingValue: Binding<DiagnosingValue>, journalListViewModel: JournalListViewModel, diagnosticViewModel: DiagnosticResultViewModel) {
        self._diagnosingValue = diagnosingValue
        self.journalListViewModel = journalListViewModel
        self.diagnosticViewModel = diagnosticViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21, content: {
            CustomSegment<DiagnosingSegment>(selectedSegment: $diagnosingValue.selectedSegment)
            
            itemsButton
        })
        .frame(width: 353, height: 78, alignment: .leading)
        .background(Color.clear)
    }
    
    private var itemsButton: some View {
        HStack(alignment: .center, spacing: 15, content: {
            ForEach(PartItem.allCases, id: \.self) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        diagnosingValue.selectedPartItem = item
                        switch diagnosingValue.selectedSegment {
                            
                        case .journalList:
                            journalListViewModel.recordList.removeAll()
                            journalListViewModel.currentPage = 0
                            journalListViewModel.canLoadMore = true
                            journalListViewModel.getJournalList(category: item.rawValue, page: 0)
                            
                        case .diagnosticResults:
                            diagnosticViewModel.diagResultListResponse.removeAll()
                            diagnosticViewModel.currentPage = 0
                            diagnosticViewModel.canLoadMore = true
                            diagnosticViewModel.getDiagResultList(category: item.rawValue, page: 0)
                        }
                    }
                }, label: {
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
                })
                .disabled(journalListViewModel.isFetching)
            }
        })
    }
}
