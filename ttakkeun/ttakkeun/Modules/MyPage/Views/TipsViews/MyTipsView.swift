//
//  MyTips.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct MyTipsView: View {
    
    @State var response: [TipsResponse]
    
    var body: some View {
        VStack {
            CustomNavigation(action: { print("hello world") },
                             title: "내가 쓴 tips",
                             currentPage: nil,
                             naviIcon: Image(systemName: "chevron.backward"),
                             width: 8,
                             height: 16)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 20) {
                    ForEach($response, id: \.id) { $tip in
                        TipsContentsCard(
                            data: $tip,
                            tipsType: .writeMyTips,
                            tipsButtonOption: TipsButtonOption(
                                heartAction: { print("Heart action") },
                                scrapAction: { print("Scrap action") }
                            ),
                            showReportBtn: false
                        )
                    }
                }
                .padding()
            }
        }
    }
}

extension MyTipsView {
    static var sampleTips: [TipsResponse] {
        [
            TipsResponse(tipId: 1, category: .ear, title: "Tip 1", content: "Content for tip 1", recommendCount: 10, createdAt: "24.10.11", imageUrls: ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg", "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"], authorName: "User", isLike: false, isPopular: true, isScrap: true)
        ]
    }
}

//MARK: - Preview
struct MyTipsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyTipsView(response: MyTipsView.sampleTips)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
