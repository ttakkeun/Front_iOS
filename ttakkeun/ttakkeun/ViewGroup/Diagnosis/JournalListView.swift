//
//  JournalListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import SwiftUI

/// 일지 목록 바디 뷰, 조회된 일지 리스트 불러온다.
struct JournalListView: View {
    
    @ObservedObject var viewModel: JournalListViewModel
    
    // MARK: - Init
    
    init(viewModel: JournalListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        LazyList
    }
    
    // MARK: - Contents
    
    /// 일지 리스트 반복 생성
    @ViewBuilder
    private var LazyList: some View {
        
        if let data = viewModel.journalListData?.result.recordList {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 102), spacing: 20), count: 3), spacing: 28, content: {
                    ForEach(data, id: \.self) { record in
                        JournalListCard(data: record,
                                        part: viewModel.journalListData?.result.category ?? .ear,
                                        isSelected: Binding(
                                            get: { viewModel.selectedItem.contains(record.recordID) },
                                            set: { isSelected in
                                                if isSelected {
                                                    viewModel.selectedItem.insert(record.recordID)
                                                } else {
                                                    viewModel.selectedItem.remove(record.recordID)
                                                }
                                                viewModel.selectedCnt = viewModel.selectedItem.count
                                            }
                                        ))
                        if let lastIndex = viewModel.journalListData?.result.recordList.lastIndex(where: { $0 == record}), lastIndex >= (viewModel.journalListData?.result.recordList.count ?? 0) - 6 {
                            ProgressView()
                                .onAppear() {
                                    Task {
                                        await viewModel.loadMorePageData(for: record)
                                    }
                                }
                        }
                    }
                    if viewModel.isLoaadingPage {
                        ProgressView()
                    }
                })
            }
            .frame(maxWidth: .infinity)
        } else {
            VStack {
                NotJournalList()
                Spacer()
            }
        }
    }
}

