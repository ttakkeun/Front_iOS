//
//  DiagnosListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import SwiftUI

struct DiagnosListView: View {
    
    @Bindable var viewModel: DiagnosticResultViewModel
    @Binding var selectedPartItem: PartItem
    
    var body: some View {
        if viewModel.diagResultListResponse.isEmpty {
            emptyDiagList
        } else {
            diagnosticList
        }
    }
    
    private var diagnosticList: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, content: {
                ZStack(alignment: .top, content: {
                    Icon.profileCat.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 114, height: 102)
                        .zIndex(1)
                    
                    LazyVStack(spacing: 0, content: {
                        ForEach(viewModel.diagResultListResponse, id: \.id) { data in
                                DiagnosisTower(data: data) {
                                    viewModel.selectedDiagId = data.diagnose_id
                                    viewModel.isShowDetailDiag = true
                                }
                                .task {
                                    guard !viewModel.diagResultListResponse.isEmpty else { return }
                                    
                                    if data == viewModel.diagResultListResponse.last && viewModel.canLoadMore {
                                        viewModel.getDiagResultList(category: self.selectedPartItem.rawValue, page: viewModel.currentPage)
                                    }
                                }
                            }
                        
                        if viewModel.isFetching {
                            ProgressView()
                                .controlSize(.regular)
                        }
                       
                    })
                    .frame(alignment: .bottom)
                    .padding(.top, 75)
                    .padding(.bottom, 80)
                    .zIndex(0)
                })
                .frame(minHeight: 750)
            })
            .frame(maxHeight: 590)
            .onAppear {
                if let lastID = viewModel.diagResultListResponse.last?.id {
                    scrollProxy.scrollTo(lastID, anchor: .bottom) // 초기 위치를 마지막 항목으로 설정
                }
            }
            .refreshable {
                viewModel.getDiagResultList(category: selectedPartItem.rawValue, page: 0, refresh: true)
            }
        }
        .sheet(isPresented: $viewModel.isShowDetailDiag, content: {
            if let id = viewModel.selectedDiagId {
                DiagnosingResultDetailView(viewModel: viewModel, showFullScreenAI: .constant(false), diagId: id)
                    .presentationCornerRadius(30)
            }
        })
    }
    
    private var emptyDiagList: some View {
        VStack(spacing: 19, content: {
            Spacer()
            
            Text("아직 생성된 진단 기록이 없어요!! \n 일지 작성 후, 진단을 해보세요!")
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
            
            Spacer()
        })
    }
}
