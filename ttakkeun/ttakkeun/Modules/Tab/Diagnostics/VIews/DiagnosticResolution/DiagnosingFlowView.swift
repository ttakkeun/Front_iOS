//
//  DiagnosingMergeView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/9/24.
//

import SwiftUI

/// 진단 중 Flow View
struct DiagnosingFlowView: View {
    
    @Bindable var viewModel: JournalListViewModel
    @EnvironmentObject var container: DIContainer
    
    @ViewBuilder
    var body: some View {
        if viewModel.isShowMakeDiagLoading {
            DiagnosingView()
        } else {
            DiagnosingResultDetailView(viewModel: .init(container: container), showFullScreenAI: $viewModel.showFullScreenAI, diagId: viewModel.diagResultResponse?.result_id ?? 0)
        }
    }
}
