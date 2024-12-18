//
//  DiagnosListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import SwiftUI

struct DiagnosListView: View {
    
    @ObservedObject var viewModel: DiagnosticResultViewModel
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, content: {
                ZStack(alignment: .top, content: {
                    Icon.profileCat.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 114, height: 102)
                        .zIndex(1)
                    
                    LazyVStack(spacing: 0, content: {
                        if let date = viewModel.diagResultListResponse?.diagnoses {
                            ForEach(date, id: \.id) { data in
                                DiagnosisTower(data: data) {
                                    viewModel.selectedDiagId = data.diagnose_id
                                    viewModel.isShowDetailDiag = true
                                }
                            }
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
                if let lastID = viewModel.diagResultListResponse?.diagnoses.last?.id {
                    scrollProxy.scrollTo(lastID, anchor: .bottom) // 초기 위치를 마지막 항목으로 설정
                }
            }
        }
        sheet(isPresented: $viewModel.isShowDetailDiag, content: {
            if let id = viewModel.selectedDiagId {
                DiagnosingResultDetailView(viewModel: viewModel, showFullScreenAI: .constant(false), diagId: id)
                    .presentationCornerRadius(30)
            }
        })
    }
}
