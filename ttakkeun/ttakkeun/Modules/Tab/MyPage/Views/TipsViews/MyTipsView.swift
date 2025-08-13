//
//  MyTips.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

// TODO: - API 작성 시 완성하기
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
                
            })
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: MyTipsContents.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: MyTipsContents.naviBackImage))
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
    }
    
    /// 내가 쓴 tips 콘텐츠들
    // TODO: - 팁스 조회 작성하기
//    private var contents: some View {
//        LazyVStack(spacing: 20) {
//            ForEach($response, id: \.id) { $tip in
//                TipsContentsCard(
//                    data: $tip,
//                    tipsType: .writeMyTips,
//                    deleteTipsAction: {
//                        //TODO: - 삭제하기 버튼 액션 필요
//                        print("Delete button tapped for \(tip.title)")
//                    }
//                )
//            }
//        }
//    }
}
