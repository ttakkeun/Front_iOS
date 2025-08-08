//
//  MyTips.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct MyTipsView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: MyTipsViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "내가 쓴 tips",
                             currentPage: nil)
            
            ScrollView(.vertical, content: {
//                contents
            })
        })
        .navigationBarBackButtonHidden(true)
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

//MARK: - Preview
struct MyTipsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyTipsView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}
