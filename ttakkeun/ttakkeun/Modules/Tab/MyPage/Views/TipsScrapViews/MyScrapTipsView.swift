//
//  MyScrapTips.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct MyScrapTipsView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyScrapTipsViewModel
    
    // MARK: - Constants
    fileprivate enum MyScrapTipsConstants {
        static let contentsVspacing: CGFloat = 30
        static let naviTitle: String = "내가 스크랩한 tips"
        static let naviBackImage: String = "chevron.left"
    }
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    var body: some View {
        ScrollView(.vertical, content: {
            LazyVStack(spacing: MyScrapTipsConstants.contentsVspacing, content: {
                ForEach($viewModel.myScrapTips, id: \.id) { $tip in
                    TipsContentsCard(
                        data: $tip,
                        tipsType: .scrapTips,
                        tipsButtonOption: .init(
                            heartAction: {
                                viewModel.toggleLike(for: tip.tipId)
                            },
                            scrapAction: {
                                viewModel.toggleBookMark(for: tip.tipId)
                            }),
                        reportActoin: {
                        container.navigationRouter.push(to: .tips(.tipsReport(tipId: tip.tipId)))
                    })
                    .task(id: tip.id) {
                        guard !viewModel.myScrapTips.isEmpty else { return}
                        
                        if tip == viewModel.myScrapTips.last && viewModel.canLoadMore {
                            viewModel.getMyScrapTis(page: viewModel.currentPage)
                        }
                    }
                }
            })
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: MyScrapTipsConstants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: MyScrapTipsConstants.naviBackImage))
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
        .task {
            viewModel.getMyScrapTis(page: .zero)
        }
    }
}
