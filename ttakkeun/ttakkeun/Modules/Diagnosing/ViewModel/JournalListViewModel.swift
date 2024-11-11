//
//  JournalListViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation

class JournalListViewModel: ObservableObject {
    @Published var isSelectionMode: Bool = false
    @Published var selectedCnt: Int = 0
    @Published var journalListData: JournalListResponse?
    
    @Published var selectedItem: Set<Int> = []
    @Published var showDetailJournalList: Bool = false
}
