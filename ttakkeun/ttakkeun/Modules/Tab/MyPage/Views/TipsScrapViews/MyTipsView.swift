//
//  MyTips.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct MyTipsView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyTipsViewModel
    
    // MARK: - Constants
    fileprivate enum MyTipsContents {
        static let contentsVspacing: CGFloat = 20
        static let naviTitle: String = "내가 쓴 tips"
        static let naviBackImage: String = "chevron.left"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    var body: some View {
        ScrollView(.vertical, content: {
            LazyVStack(spacing: MyTipsContents.contentsVspacing, content: {
                if viewModel.myWriteTips.isEmpty {
                    NotRecommend(recommendType: .noMyWriteTip)
                } else {
                    myWriteTips
                }
            })
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: MyTipsContents.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: MyTipsContents.naviBackImage))
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
        .task {
            viewModel.getMyTips(page: .zero)
        }
    }
    
    private var myWriteTips: some View {
        ForEach($viewModel.myWriteTips, id: \.id) { $tip in
            TipsContentsCard(data: $tip, tipsType: .writeMyTips, deleteTipsAction: {
                viewModel.deleteTips(tipId: tip.tipId)
            }, reportActoin: { })
            .task {
                guard tip == viewModel.myWriteTips.last && viewModel.canLoadMore else { return }
                viewModel.getMyTips(page: viewModel.currentPage)
            }
        }
    }
}

#Preview {
    MyTipsView(container: DIContainer())
        .environmentObject(DIContainer())
}
