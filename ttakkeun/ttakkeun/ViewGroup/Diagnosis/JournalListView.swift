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
    @State var isShowFullScreen: Bool = false
    
    // MARK: - Init
    
    init(viewModel: JournalListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LazyList
                self.makeJournalList
                    .position(x: geo.size.width * 0.8, y: geo.size.height * 0.7)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isLoadingDiag, content: {
            DiagnosisResultDetailView(viewModel: viewModel)
        })
    }
    
    // MARK: - Contents
    
    /// 일지 리스트 반복 생성
    @ViewBuilder
    private var LazyList: some View {
        
        if let data = viewModel.journalListData?.recordList {
            if data.isEmpty {
                EmptyLazyListView
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 102), spacing: 20), count: 3), spacing: 28, content: {
                        ForEach(data, id: \.self) { record in
                            JournalListCard(data: record,
                                            part: viewModel.journalListData?.category ?? .ear,
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
                            .onTapGesture {
                                if viewModel.isSelectionMode {
                                    if viewModel.selectedItem.contains(record.recordID) {
                                        viewModel.selectedItem.remove(record.recordID)
                                    } else {
                                        viewModel.selectedItem.insert(record.recordID)
                                    }
                                    viewModel.selectedCnt = viewModel.selectedItem.count
                                } else {
                                    self.viewModel.getDetailQnA(recordId: record.recordID) { success in
                                        if success {
                                            self.isShowFullScreen = true
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                if record == data.last && !viewModel.isLastPage {
                                    viewModel.currentPage += 1
                                        viewModel.getJournalList(page: viewModel.currentPage)
                                }
                            }
                        }
                    })
                    .padding(.bottom, 110)
                }
                .frame(maxWidth: .infinity)
                .fullScreenCover(isPresented: $isShowFullScreen, content: {
                    if let data = self.viewModel.checkJournalQnAResponseData {
                        CheckQnAView(data: data)
                    } else {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                })
            }
        } else {
            EmptyLazyListView
        }
    }
    
    /// 데이터가 비었을 시 뷰,,
    private var EmptyLazyListView: some View {
        VStack {
            NotJournalList()
            Spacer()
        }
    }
    
    private var makeJournalList: some View {
        Button(action: {
            if !viewModel.isSelectionMode {
                viewModel.goToMakeDiagnosis()
            } else {
                viewModel.makeDiag { success in
                    if success {
                        viewModel.getDiagDetail { success in
                            print("상세 결과 받아오기 성공")
                        }
                    }
                }
            }
        }, label: {
            ZStack {
                Circle()
                    .fill(Color.primaryColor_Main)
                    .frame(width: 67, height: 67)
                
                if self.viewModel.isSelectionMode {
                    Text("따끈 AI \n진단하기")
                        .font(.suit(type: .bold, size: 12))
                        .foregroundStyle(Color.gray_900)
                } else {
                    Icon.diagPencil.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 27)
                }
            }
        })
    }
}

