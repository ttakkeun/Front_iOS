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
    
    @Published var journalListData: JournalListResponse? = JournalListResponse(category: .ear, recordList: [JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 2, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 3, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 4, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 5, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 6, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 7, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 8, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 9, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 10, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 11, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 12, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 13, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 14, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 15, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 16, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 17, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 18, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 19, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 20, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 21, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 22, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 23, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 1, recordDate: "2014-01-01", recordTime: "14:58:11.123"), JournalListItem(recordID: 24, recordDate: "2014-01-01", recordTime: "14:58:11.123")])
    
    @Published var journalResultData: JournalResultResponse?
    
    @Published var selectedItem: Set<UUID> = []
    @Published var showDetailJournalList: Bool = false
    
    @Published var showAiDiagnosing: Bool = false
    @Published var aiPoint: Int = 10
}
