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
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    @Binding var showAlert: Bool
    @Binding var alertText: Text
    @Binding var aiCount: Int
    @Binding var alertType: AlertType
    @Binding var selectedPartItem: PartItem
    
    init(viewModel: JournalListViewModel, showAlert: Binding<Bool>, alertText: Binding<Text>, aiCount: Binding<Int>, alertType: Binding<AlertType>, selectedPartItem: Binding<PartItem>) {
        self.viewModel = viewModel
        self._showAlert = showAlert
        self._alertText = alertText
        self._aiCount = aiCount
        self._alertType = alertType
        self._selectedPartItem = selectedPartItem
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                journalList
                makeJournalListBtn
                    .position(x: geo.size.width * 0.76, y: geo.size.height * 0.74)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            }
        }
        .onChange(of: viewModel.showAiDiagnosing, {
            showAlert = true
            alertText = self.alertTextString()
            aiCount = viewModel.aiPoint
            alertType = .aiAlert
        })
        .task {
            if viewModel.recordList.isEmpty {
                viewModel.getJournalList(category: selectedPartItem.rawValue, page: 0)
            }
        }
        .sheet(isPresented: $viewModel.isShowDetailJournal, content: {
                JournalResultCheckView(viewModel: viewModel)
        })
    }
    
    @ViewBuilder
    private var journalList: some View {
        if viewModel.recordList.isEmpty {
            EmptyJournalList
        } else {
            ScrollView(.vertical, content: {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(102), spacing: 20), count: 3), spacing: 28, content: {
                    ForEach(viewModel.recordList, id: \.id) { record in
                        JournalListCard(cardData: JournalListCardData(data: record, part: selectedPartItem),
                                        isSelected: Binding(get: {
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
                                self.viewModel.getDetailJournalData(recordId: record.recordID)
                            }
                        }
                        .task {
                            if record == viewModel.recordList.last {
                                viewModel.getJournalList(category: selectedPartItem.rawValue, page: viewModel.currentPage)
                            }
                        }
                    }
                })
                .padding(.top, 10)
                .padding(.bottom, 80)
            })
            .frame(maxWidth: .infinity)
        }
    }
    
    private var EmptyJournalList: some View {
        VStack(spacing: 19, content: {
            
            Spacer().frame(height: 100)
            
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
                container.navigationRouter.push(to: .makeJournalist)
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
