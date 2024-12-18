//
//  MyScrapTips.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct MyScrapTipsView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: MyPageViewModel
    
    @State var response: [TipsResponse]
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
        self.response = MyTipsView.sampleTips
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "내가 스크랩한 tips",
                             currentPage: nil)
            
            ScrollView(.vertical, content: {
                contents
            })
        })
        .navigationBarBackButtonHidden(true)
    }
    
    /// 내가 스크랩한 tips 콘텐츠들
    private var contents: some View {
        LazyVStack(spacing: 20) {
            ForEach($response, id: \.id) { $tip in
                TipsContentsCard(
                    data: $tip,
                    tipsType: .scrapTips,
                    tipsButtonOption: TipsButtonOption(
                        //TODO: - 좋아요, 스크랩 버튼 액션 필요
                        heartAction: { print("좋아요 버튼 눌림") },
                        scrapAction: { print("스크랩 버튼 눌림") })
                )
            }
        }
    }
}

extension MyScrapTipsView {
    static var sampleTips: [TipsResponse] {
        [
            TipsResponse(tipId: 0, category: .ear, title: "Tip 1", content: "강아지 귀를 잘 청소하는 방법을 설명해드리겠습니다. 먼저 귀 세척액을 비싼 것으로 사세요. 좋은 거로요! 그리고 강아지용 큰 면봉도 사세요. 그리고 큰 면봉에 세척액을 촉촉하게 묻혀주세요. 그리고 귀 안쪽을 살살 닦아주면 된답니다? 참 쉽죠?", recommendCount: 50, createdAt: "2024-11-14T05:20:00.08Z", authorName: "황유빈", isLike: false, isPopular: true, isScrap: true),
            
            TipsResponse(tipId: 1, category: .claw, title: "털 안꼬이게 빗는 법 꿀팁 공유 드림", content: "털은 빗어주지 않으면 쉽게 꼬일 수 있기 때문에 열심히 빗어주면 됩니다. 그래서 매일매일 빗질을 해주는 것이 매우 중요합니다. 털의 길이와 상태에 따라 길이와 상태에 따라 종류에 맞는 빗을 구매하셔서 부드럽게 털을 빗어 죽은 털을 제거해주세요 그러면 윤기나고 건강한 털을 유지할 수 있습니다. 하하하하하하하하", recommendCount: 1000, createdAt: "2024-12-12T02:20:00.08Z", imageUrls: ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg", "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"], authorName: "정의찬", isLike: false, isPopular: true, isScrap: true)
        ]
    }
}

//MARK: - Preview
struct MyScrapTipsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyScrapTipsView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}
