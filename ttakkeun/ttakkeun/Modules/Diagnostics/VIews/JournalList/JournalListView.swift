//
//  JournalListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 진단 목록 뷰
struct JournalListView: View {
    
    @ObservedObject var viewModel: JournalListViewModel
    
    @Binding var showAlert: Bool
    @Binding var alertText: Text
    @Binding var aiCount: Int
    @Binding var alertType: AlertType
    
    init(viewModel: JournalListViewModel, showAlert: Binding<Bool>, alertText: Binding<Text>, aiCount: Binding<Int>, alertType: Binding<AlertType>) {
        self.viewModel = viewModel
        self._showAlert = showAlert
        self._alertText = alertText
        self._aiCount = aiCount
        self._alertType = alertType
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                journalList
                makeJournalListBtn
                    .position(x: geo.size.width * 0.76, y: geo.size.height * 0.74)
            }
        }
        .onChange(of: viewModel.showAiDiagnosing, {
                showAlert = true
                alertText = self.alertTextString()
                aiCount = viewModel.aiPoint
                alertType = .aiAlert
        })
    }
    
    @ViewBuilder
    private var journalList: some View {
        if let data = viewModel.journalListData?.recordList {
            if data.isEmpty {
                EmptyJournalList
            } else {
                ScrollView(.vertical, content: {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(102), spacing: 20), count: 3), spacing: 28, content: {
                        ForEach(data, id: \.id) { record in
                            JournalListCard(cardData: JournalListCardData(data: record, part: viewModel.journalListData?.category ?? .ear), isSelected: Binding(get: {
                                viewModel.selectedItem.contains(record.id)
                            }, set: {
                                isSelected in
                                if isSelected {
                                    viewModel.selectedItem.insert(record.id)
                                } else {
                                    viewModel.selectedItem.remove(record.id)
                                }
                                viewModel.selectedCnt = viewModel.selectedItem.count
                            }))
                            .onTapGesture {
                                if viewModel.isSelectionMode {
                                    if viewModel.selectedItem.contains(record.id) {
                                        viewModel.selectedItem.remove(record.id)
                                        print(viewModel.selectedItem)
                                    } else {
                                        viewModel.selectedItem.insert(record.id)
                                        print(viewModel.selectedItem)
                                    }
                                    viewModel.selectedCnt = viewModel.selectedItem.count
                                } else {
                                    // TODO: - 일지 상세 보기 구현하기
                                    print("상세 보기")
                                }
                            }
                        }
                    })
                    .padding(.top, 10)
                    .padding(.bottom, 80)
                })
                .frame(maxWidth: .infinity)
            }
        } else {
            EmptyJournalList
        }
    }
    
    private var EmptyJournalList: some View {
        VStack(spacing:19, content: {
            
            Spacer()
            
            Icon.noJournal.image
                .fixedSize()
            
            Text("일지가 아직 없네요! \n오늘의 반려동물 일지를 작성해보세요!")
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
            
            Spacer()
        })
    }
    
    private var makeJournalListBtn: some View {
        Button(action: {
            if !viewModel.isSelectionMode {
                print("선택된 모드 아닐 때")
            } else {
                if viewModel.selectedCnt >= 1 {
                    viewModel.showAiDiagnosing.toggle()
                }
            }
        }, label: {
            HStack(alignment: .center, spacing: 5, content: {
                changeIcon()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                
                changeText()
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
            })
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.primarycolor400)
                    .shadow03()
            }
            .animation(.easeInOut, value: viewModel.isSelectionMode)
        })
    }
}

extension JournalListView {
    func changeIcon() -> Image {
        if viewModel.isSelectionMode {
            Icon.aiPen.image
        } else {
            Icon.pen.image
        }
    }
    
    func changeText() -> Text {
        if viewModel.isSelectionMode {
            Text("따끈 AI 진단하기")
        } else {
            Text("따끈 일지 생성하기")
        }
    }
    
    func alertTextString() -> Text {
        let baseText = "선택된 \(viewModel.selectedItem.count)개의 일지로 \n따끈 AI 진단을 진행하시겠습니까? \n"
        let aiCountText = "(현재 가능한 횟수 : \(viewModel.aiPoint)회)"
        
        return Text(baseText) + Text(aiCountText).foregroundStyle(Color.red).font(.Body5_semiBold)
    }
}
