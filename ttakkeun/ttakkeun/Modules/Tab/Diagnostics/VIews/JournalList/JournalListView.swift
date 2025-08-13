//
//  JournalListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 진단 목록 뷰
struct JournalListView: View {
    
    // MARK: - Property
    @Bindable var viewModel: JournalListViewModel
    @Binding var selectedPartItem: PartItem
    @EnvironmentObject var container: DIContainer
    @Environment(\.alert) var alert
    @AppStorage(AppStorageKey.aiCount) var aiCount: Int?
    
    // MARK: - Constants
    fileprivate enum JournalListConstants {
        static let journalListTopPadding: CGFloat = 10
        
        static let emptyJournalListVspacing: CGFloat = 19
        static let columsHSpacing: CGFloat = 20
        static let columsVspacing: CGFloat = 28
        static let columsCount: Int = 3
        static let bottomBtnHspacing: CGFloat = 5
        static let bottomBtnSize: CGFloat = 18
        static let bottomPadding: CGFloat = 10
        static let bottomCornerRadius: CGFloat = 20
        static let bottomTrailingPadding: CGFloat = 10
        
        static let createJournalText: String = "따끈 일지 생성하기"
        static let aiDiagnoseText: String = "따끈 AI 진단하기"
        static let emptyJournalText: String = "일지가 아직 없네요! \n오늘의 반려동물 일지를 작성해보세요!"
    }
    
    var body: some View {
        ZStack {
            middleContents
            bottomContentsBtn
        }
        .task {
            guard viewModel.recordList.isEmpty else { return }
            viewModel.getJournalList(category: selectedPartItem.rawValue, page: .zero)
        }
        .sheet(item: $viewModel.journalResultData, content: { journalResultData in
            JournalResultCheckView(journalResultResponse: journalResultData)
                .presentationCornerRadius(UIConstants.sheetCornerRadius)
        })
    }
    
    // MARK: - MiddleContents
    /// 일지 기록 컨텐츠
    @ViewBuilder
    private var middleContents: some View {
        if viewModel.recordList.isEmpty {
            emptyJournalList
        } else {
            existJournalList
        }
    }
    
    /// 일지 로딩 표시
    @ViewBuilder
    private var journalListLoading: some View {
        if viewModel.isFetching {
            ProgressView()
                .controlSize(.regular)
        }
    }
    
    /// 일지 리스트 존재할 경우
    @ViewBuilder
    private var existJournalList: some View {
        let colunms = Array(repeating: GridItem(.flexible(), spacing: JournalListConstants.columsHSpacing), count: JournalListConstants.columsCount)
        
        ScrollView(.vertical, content: {
            LazyVGrid(columns: colunms, spacing: JournalListConstants.columsVspacing, content: {
                ForEach(viewModel.recordList, id: \.id) { record in
                    JournalListCard(
                        cardData: .init(data: record, part: selectedPartItem),
                        isSelected: isCardSelected(record: record)
                    )
                    .onTapGesture {
                        cardTapGestureAction(record: record)
                    }
                    .task(id: selectedPartItem) {
                        guard !viewModel.recordList.isEmpty else { return }
                        
                        if record == viewModel.recordList.last && viewModel.canLoadMore {
                            viewModel.getJournalList(category: selectedPartItem.rawValue, page: viewModel.currentPage)
                        }
                    }
                }
                
                if viewModel.isFetching {
                    ProgressView()
                        .controlSize(.regular)
                }
            })
            .padding(.top, JournalListConstants.journalListTopPadding)
        })
        .contentMargins(.horizontal, UIConstants.safeLeading, for: .scrollContent)
        .contentMargins(.bottom, UIConstants.safeBottom, for: .scrollContent)
        .refreshable {
            viewModel.getJournalList(category: selectedPartItem.rawValue, page: .zero, refresh: true)
        }
    }
    
    /// 일지 리스트 비워졌을 경우 보이기
    private var emptyJournalList: some View {
        VStack(spacing: JournalListConstants.emptyJournalListVspacing, content: {
            Image(.noJournal)
            
            Text(JournalListConstants.emptyJournalText)
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
        })
    }
    
    // MARK: - BottomArea
    
    /// 1. 일지 생성,
    /// 2. 일지 기반 ai 진단하기
    private var bottomContentsBtn: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    bottomBtnAction()
                }, label: {
                    bottomBtnContent
                })
            }
            .padding(.trailing, JournalListConstants.bottomTrailingPadding)
            .padding(.bottom, UIConstants.defaultSafeBottom)
        }
    }
    
    /// 하단 버튼
    private var bottomBtnContent: some View {
        HStack(alignment: .center, spacing: JournalListConstants.bottomBtnHspacing, content: {
            changeIcon()
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: JournalListConstants.bottomBtnSize, height: JournalListConstants.bottomBtnSize)
            
            changeText()
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
        })
        .padding(JournalListConstants.bottomPadding)
        .background {
            RoundedRectangle(cornerRadius: JournalListConstants.bottomCornerRadius)
                .fill(Color.primarycolor400)
                .shadow03()
        }
        .animation(.easeInOut, value: viewModel.isSelectionMode)
    }
    
    private func bottomBtnAction() -> Void {
        if !viewModel.isSelectionMode {
            container.navigationRouter.push(to: .diagnostic(.makeJournalist))
        } else {
            if viewModel.selectedCnt >= 1 {
                viewModel.patchUserPoint()
                viewModel.getUserPoint()
                showAletAction()
            }
        }
    }
    
    /// AlertAction분기
    private func showAletAction() {
        viewModel.showDiagnosedAlert = true
        
        if viewModel.aiPoint == .zero {
            alert.trigger(type: .noAiCountAlert, showAlert: viewModel.showDiagnosedAlert)
        } else {
            alert.trigger(type: .aiAlert(count: viewModel.selectedCnt, aiCount: viewModel.aiPoint), showAlert: viewModel.showDiagnosedAlert, action: {
                viewModel.showFullScreenAI = true
                viewModel.makeDiag()
            })
        }
    }
}

extension JournalListView {
    func changeIcon() -> Image {
        if viewModel.isSelectionMode {
            Image(.aiPen)
        } else {
            Image(.pen)
        }
    }
    
    func changeText() -> Text {
        if viewModel.isSelectionMode {
            Text(JournalListConstants.aiDiagnoseText)
        } else {
            Text(JournalListConstants.createJournalText)
        }
    }
    
    /// 일지 선택했는가 판단
    /// - Parameter record: 일지 자체 데이터
    /// - Returns: 바인딩된 Bool qksghks
    func isCardSelected(record: JournalListItem) -> Binding<Bool> {
        return Binding(get: {
            viewModel.selectedItem.contains(record.recordID)
        }, set: {
            isSelected in
            if isSelected {
                viewModel.selectedItem.insert(record.recordID)
            } else {
                viewModel.selectedItem.remove(record.recordID)
            }
            viewModel.selectedCnt = viewModel.selectedItem.count
        })
    }
    
    /// 일지 카드 선택 시 실행 액션
    /// - Parameter record: 일지 자체 데이터
    /// - Returns: 액션 반환
    func cardTapGestureAction(record: JournalListItem) -> Void {
        if viewModel.isSelectionMode {
            if viewModel.selectedItem.contains(record.recordID) {
                viewModel.selectedItem.remove(record.recordID)
            } else {
                viewModel.selectedItem.insert(record.recordID)
            }
            viewModel.selectedCnt = viewModel.selectedItem.count
        } else {
            self.viewModel.getDetailJournalData(recordId: record.recordID)
        }
    }
}

#Preview {
    JournalListView(viewModel: .init(container: DIContainer()), selectedPartItem: .constant(.claw))
        .environment(AlertStateModel())
        .environmentObject(DIContainer())
}
