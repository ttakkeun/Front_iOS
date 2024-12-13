//
//  TipsContentsCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI
import Kingfisher

struct TipsContentsCard: View {
    
    @EnvironmentObject var container: DIContainer
    @Binding var data: TipsResponse
    let tipsType: TipsType
    
    let tipsButtonOption: TipsButtonOption?
    let deleteTipsAction: (() -> Void)?
    
    let showReportBtn: Bool
    
    init(data: Binding<TipsResponse>,
         tipsType: TipsType,
         tipsButtonOption: TipsButtonOption? = nil,
         deleteTipsAction: (() -> Void)? = nil,
         showReportBtn: Bool = true
    ) {
        self._data = data
        self.tipsType = tipsType
        self.tipsButtonOption = tipsButtonOption
        self.deleteTipsAction = deleteTipsAction
        self.showReportBtn = showReportBtn
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            topTagInfo
            
            if data.isExpand {
                afterExpandTopContents
                    .transition(.opacity.combined(with: .blurReplace))
            } else {
                beforeExpandTopContents
            }
            bottomOption
        })
        .padding(.vertical, 12)
        .padding(.leading, 14)
        .padding(.trailing, 18)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.grayBorder)
        }
        .animation(.bouncy(duration: 0.5), value: data.isExpand)
    }
    
    // MARK: - MainContents
    
    private var topTagInfo: some View {
        HStack(spacing: 4, content: {
            makeTag(text: data.category.toKorean(), color: data.category.toColor())
            
            bestTag
            
            if let tipsButtonOption = tipsButtonOption {
                likeScrapButton(tipsButtonOption: tipsButtonOption)
            }
            
            if let deleteTipsAction = deleteTipsAction {
                deleteButton(deleteAction: deleteTipsAction)
            }
        })
        .frame(width: 323)
    }
    
    private var beforeExpandTopContents: some View {
        HStack(content: {
            
            topTextContents
            
            Spacer()
            
            contentsImage
        })
        .frame(width: 326, height: 73)
    }
    
    private var afterExpandTopContents: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            topTextContents
            
            expandContentsImage
        })
        .frame(width: 323)
    }
    
    private var bottomOption: some View {
        HStack(content: {
            bottomTipsInfo
            
            Spacer()
            
            moreInfoBtn
        })
        .frame(width: 326)
    }
    
    
    private var topTextContents: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            title
            content
        })
    }
    

    // MARK: - TopTagButton
    
    @ViewBuilder
    private var bestTag: some View {
        if data.isPopular {
            makeTag(text: "인기", color: Color.yellow)
            
            Spacer()
        } else {
            Spacer()
        }
    }
    
    // MARK: - Contents
    
    /// 제목
    private var title: some View {
        Text(data.title)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
    }

    private var content: some View {
        Text(data.content.split(separator: " ").joined(separator: "\u{200B}"))
            .frame(maxWidth: data.isExpand ? 322 : 215, alignment: .leading)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray300)
            .lineSpacing(1.5)
            .lineLimit(data.isExpand ? nil : 2)
            .multilineTextAlignment(.leading)
            .truncationMode(.tail)
    }
    
    @ViewBuilder
    private var expandContentsImage: some View {
        if let imageUrls = data.imageUrls, !imageUrls.isEmpty {
            if data.isExpand {
                ScrollView(.horizontal, content: {
                    HStack(spacing: 10, content: {
                        ForEach(imageUrls.prefix(3), id: \.self) { url in
                            makeImage(imageUrl: url)
                        }
                    })
                })
            }
        }
    }
    
    @ViewBuilder
    private var contentsImage: some View {
        if let imageUrls = data.imageUrls, !imageUrls.isEmpty {
            ZStack(alignment: .bottomTrailing, content: {
                makeImage(imageUrl: imageUrls[0])
                
                makeCountTag(count: imageUrls.count)
            })
        }
    }
    
    @ViewBuilder private var bottomTipsInfo: some View {
        switch tipsType {
        case .writeMyTips:
            myWriteTipsInfo
        case .scrapTips:
            userNameElapsedTime
        }
    }
    
    private var userNameElapsedTime: some View {
        HStack(spacing: 6, content: {
            Group {
                Text(DataFormatter.shared.maskUserName(data.authorName))
                
                Text(DataFormatter.shared.changeDifferenceTime(from: data.createdAt))
            }
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
        })
    }
    
    private var myWriteTipsInfo: some View {
        HStack(spacing: 8, content: {
            Group {
                Text(DataFormatter.shared.convertToKoreanTime(from: data.createdAt))
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
                
                HStack(spacing: 3, content: {
                    Image(systemName: "heart")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 12, height: 12)
                        .foregroundStyle(Color.gray600)
                    
                    Text(data.recommendCount <= 999 ? "\(data.recommendCount)" : "999+")
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray600)
                })
            }
        })
    }
    
    private var moreInfoBtn: some View {
        Button(action: {
            withAnimation {
                data.isExpand.toggle()
            }
        }, label: {
            Text(data.isExpand ? "접기" : "펼치기")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
                .underline()
        })
    }
}

extension TipsContentsCard {
    func makeTag(text: String, color: Color) -> some View {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray900)
            .frame(width: 26, height: 18)
            .padding(.vertical, 3)
            .padding(.horizontal, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
            }
    }
    
    @ViewBuilder
    func makeImage(imageUrl: String) -> some View {
        if let url = URL(string: imageUrl) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }
                .retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 76, height: 73)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray200, lineWidth: 1)
                })
        }
    }
    
    func makeCountTag(count: Int) -> some View {
        ZStack {
            Icon.bottomRightTag.image
                .fixedSize()
            Text("\(count)")
                .font(.Detail1_bold)
                .foregroundStyle(Color.white)
        }
    }
    
    func likeScrapButton(tipsButtonOption: TipsButtonOption) -> some View {
        HStack(spacing: 10, content: {
            Button(action: {
                withAnimation {
                    tipsButtonOption.heartAction()
                }
            }, label: {
                Image(systemName: data.isLike ? "suit.heart.fill" : "suit.heart")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 19, height: 18)
                    .foregroundStyle(data.isLike ? Color.removeBtn : Color.gray600)
            })
            
            Button(action: {
                withAnimation {
                    tipsButtonOption.scrapAction()
                }
            }, label: {
                Image(systemName: data.isScrap ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 18)
                    .foregroundStyle(data.isScrap ? Color.card005 : Color.gray600)
            })
            
            Menu(content: {
                Button(action: {
                    print("신고하기 클릭")
                }, label: {
                    Label("신고하기", systemImage: "light.beacon.max")
                        .foregroundStyle(Color.gray900)
                })
            }, label: {
                Icon.dotsY.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 4, height: 16)
                    .padding(.horizontal, 5)
            })
        })
        .frame(width: 76)
    }
    
    func deleteButton(deleteAction: @escaping () -> Void) -> some View {
        Button(action: {
            deleteAction()
        },
               label: {
            Text("삭제하기")
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray600)
                .underline(true)
        })
    }
}

struct TipsButtonOption {
    let heartAction: () -> Void
    let scrapAction: () -> Void
    
    init(heartAction: @escaping () -> Void, scrapAction: @escaping () -> Void) {
        self.heartAction = heartAction
        self.scrapAction = scrapAction
    }
}

struct TipsContentsCard_Preview: PreviewProvider {
    static var previews: some View {
        TipsContentsCard(data: .constant(TipsResponse(tipId: 0, category: .ear, title: "털 안꼬이게 빗는 법 꿀팁 공유 드림", content: "털은 빗어주지 않으면 쉽게 꼬일 수 있기 때문에 열심히 빗어주면 됩니다. 그래서 매일매일 빗질을 해주는 것이 매우 중요합니다. 털의 길이와 상태에 따라 길이와 상태에 따라 종류에 맞는 빗을 구매하셔서 부드럽게 털을 빗어 죽은 털을 제거해주세요 그러면 윤기나고 건강한 털을 유지할 수 있습니다. 하하하하하하하하", recommendCount: 1000, createdAt: "2024-12-12T02:20:00.08Z", imageUrls: ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg", "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"], authorName: "정의찬", isLike: false, isPopular: true, isScrap: true)), tipsType: .scrapTips, tipsButtonOption: TipsButtonOption(heartAction: { print("hello") }, scrapAction: { print("hello") }))
            .environmentObject(DIContainer())
    }
}
