//
//  JournalRegistView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

/// 진단 등록 뷰
struct JournalRegistView: View {
    
    // MARK: - Property
    var viewModel: JournalRegistViewModel
    @EnvironmentObject var container: DIContainer
    
    // MARK: - Constants
    fileprivate enum JournalRegistConstants {
        static let closeButton: String = "xmark"
        static let navigationTitle: String = "일지 생성"
    }
    
    // MARK: - DIContainer
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
            JournalRegistContents(viewModel: viewModel)
                .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
                .navigationBarBackButtonHidden(true)
                .customNavigation(
                    title: JournalRegistConstants.navigationTitle,
                    leadingAction: {
                        container.navigationRouter.pop()
                    },
                    naviIcon: Image(systemName: JournalRegistConstants.closeButton),
                    currentPage: viewModel.currentPage
                )
                .toolbarTitleDisplayMode(.inline)
                .loadingOverlay(isLoading: viewModel.makeJournalsLoading, loadingTextType: .createJournal)
    }
}


#Preview {
    JournalRegistView(container: DIContainer())
        .environmentObject(DIContainer())
}
