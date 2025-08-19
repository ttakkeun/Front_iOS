//
//  TipsContentsCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI
import Kingfisher

/// 팁스 게시글 카드
struct TipsContentsCard: View {
    
    // MARK: - Property
    @State var isExpand: TipsExpandType = .beforeExpand
    @Binding var data: TipGenerateResponse
    let tipsType: TipsType
    
    let tipsButtonOption: TipsButtonOption?
    let deleteTipsAction: (() -> Void)?
    let reportAction: () -> Void
    
    // MARK: - Constants
    fileprivate enum TipsContentsConstants {
        static let contentsPadding: EdgeInsets = .init(top: 12, leading: 14, bottom: 12, trailing: 18)
        static let middleContentsVspacing: CGFloat = 9
        static let tagEdge: EdgeInsets = .init(top: 3, leading: 12, bottom: 3, trailing: 12)
        static let contentsVspacing: CGFloat = 16
        static let afterExpandVspacing: CGFloat = 15
        static let imageHspacing: CGFloat = 10
        static let scrapHspacing: CGFloat = 6
        static let myWriteHspacing: CGFloat = 8
        static let tagHspacing: CGFloat = 4
        static let heartHspacing: CGFloat = 3
        static let lineSpacing: CGFloat = 1.5
        
        static let contentsHeight: CGFloat = 164
        static let dotsYSize: CGSize = .init(width: 4, height: 18)
        static let dotsHorizonPadding: CGFloat = 6
        static let heartImageSize: CGSize = .init(width: 12, height: 12)
        static let imageSize: CGSize = .init(width: 76, height: 73)
        static let tagSize: CGSize = .init(width: 26, height: 18)
        static let beforeExpandCardHeight: CGFloat = 32
        
        static let cornerRadius: CGFloat = 10
        static let imageMaxCount: Int =  2
        static let imageTime: TimeInterval = 2
        static let lineLimit: Int = 2
        static let expandImageCount: Int = 3
        static let expandAnimation: TimeInterval = 0.3
        
        static let heartImage: String = "heart"
        static let lightBecomMax: String = "light.beacon.max"
        static let popularText: String = "인기"
        static let reportText: String = "신고하기"
        static let deleteText: String = "삭제하기"
    }
    
    // MARK: - Init
    init(data: Binding<TipGenerateResponse>,
         tipsType: TipsType,
         tipsButtonOption: TipsButtonOption? = nil,
         deleteTipsAction: (() -> Void)? = nil,
         reportActoin: @escaping () -> Void
    ) {
        self._data = data
        self.tipsType = tipsType
        self.tipsButtonOption = tipsButtonOption
        self.deleteTipsAction = deleteTipsAction
        self.reportAction = reportActoin
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: TipsContentsConstants.contentsVspacing, content: {
            topContents
            middleContents
            bottomContents
        })
        .padding(TipsContentsConstants.contentsPadding)
        .background {
            RoundedRectangle(cornerRadius: TipsContentsConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.grayBorder)
                .frame(maxWidth: .infinity)
        }
        .animation(.easeInOut(duration: TipsContentsConstants.expandAnimation), value: isExpand)
    }
    
    // MARK: - TopContents
    /// 상단 태그 및 버튼 옵션
    private var topContents: some View {
        HStack {
            topLeftTag
            Spacer()
            topRightOption
        }
    }
    
    /// 상단 왼쪽 태그
    private var topLeftTag: some View {
        HStack(spacing: TipsContentsConstants.tagHspacing, content: {
            makeTag(text: data.category.toKorean(), color: data.category.toColor())
            makeTag(text: TipsContentsConstants.popularText, color: Color.yellow)
        })
    }
    
    /// 상단 오른쪽 옵션
    @ViewBuilder
    private var topRightOption: some View {
        if let tipsButtonOption = tipsButtonOption {
            likeScrapButton(tipsButtonOption: tipsButtonOption)
        }
        
        if let deleteTipsAction = deleteTipsAction {
            deleteButton(deleteAction: deleteTipsAction)
        }
    }
    
    // MARK: - Button
    /// 팁스 오른쪽 버튼 재사용
    /// - Parameter type: 타입 선택
    /// - Returns: 버튼 생성
    func tipsRightButton(type: TipsLikeScrapType) -> some View {
        Button(action: {
            withAnimation {
                type.action()
            }
        }, label: {
            Image(systemName: type.image)
                .resizable()
                .renderingMode(.template)
                .frame(width: type.frame.width, height: type.frame.height)
                .foregroundStyle(type.foregroundStyle)
        })
    }
    
    /// 좋아요 및 스크랩 버튼
    /// - Parameter tipsButtonOption: 좋아요 및 스크랩 액션
    /// - Returns: 버튼 반환
    func likeScrapButton(tipsButtonOption: TipsButtonOption) -> some View {
        HStack(spacing: 10, content: {
            tipsRightButton(type: .like(isLike: data.isLike, action: {
                tipsButtonOption.heartAction()
            }))
            
            tipsRightButton(type: .scrap(isScrap: data.isScrap, action: {
                tipsButtonOption.scrapAction()
            }))
            
            Menu(content: {
                Button(action: {
                    reportAction()
                }, label: {
                    Label(TipsContentsConstants.reportText, systemImage: TipsContentsConstants.lightBecomMax)
                        .foregroundStyle(Color.gray900)
                })
            }, label: {
              menuBtnList
            })
        })
    }
    
    /// 신고 메뉴 리스트 버튼
    private var menuBtnList: some View {
        Image(.dotsY)
            .resizable()
            .frame(width: TipsContentsConstants.dotsYSize.width, height: TipsContentsConstants.dotsYSize.height)
            .padding(.horizontal, TipsContentsConstants.dotsHorizonPadding)
    }
    
    /// 삭제 버튼
    /// - Parameter deleteAction: 게시글 삭제 버튼
    /// - Returns: 삭제 버튼 반환
    func deleteButton(deleteAction: @escaping () -> Void) -> some View {
        Button(action: {
            deleteAction()
        }, label: {
            Text(TipsContentsConstants.deleteText)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray600)
                .underline(true)
        })
    }
    
    // MARK: - Middle
    /// 중간 팁스 카드 확장 전/후 분기
    @ViewBuilder
    private var middleContents: some View {
        switch isExpand {
        case .beforeExpand:
            beforeExpandTopContents
        case .afterExpand:
            afterExpandTopContents
        }
    }
    
    /// 확장 전 카드
    private var beforeExpandTopContents: some View {
        HStack(alignment: .top, content: {
            middleTextContents
            Spacer()
            beforeExpandImage
        })
        .frame(maxWidth: .infinity)
    }
    
    /// 확장 후 카드
    private var afterExpandTopContents: some View {
        VStack(alignment: .leading, spacing: TipsContentsConstants.afterExpandVspacing, content: {
            middleTextContents
            expandContentsImage
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.opacity.combined(with: .blurReplace))
    }
    
    /// 게시글 제목 + 컨텐츠 내용
    private var middleTextContents: some View {
        VStack(alignment: .leading, spacing: TipsContentsConstants.middleContentsVspacing, content: {
            title
            content
        })
    }
    /// 게시글 내용 제목
    private var title: some View {
        Text(data.title)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
            .lineLimit(TipsContentsConstants.lineLimit)
    }
    
    /// 게시글 내용
    private var content: some View {
        Text(data.content.customLineBreak())
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray300)
            .lineSpacing(TipsContentsConstants.lineSpacing)
            .lineLimit(isExpand.lineLimit)
            .multilineTextAlignment(.leading)
    }
    
    /// 팁 게시글 확장 전 이미지 표시
    @ViewBuilder
    private var beforeExpandImage: some View {
        if let imageUrls = data.imageUrls, !imageUrls.isEmpty {
            ZStack(alignment: .bottomTrailing, content: {
                makeImage(imageUrl: imageUrls[0])
                makeCountTag(count: imageUrls.count)
            })
        }
    }
    
    /// 확장 후 이미지 컨텐츠
    @ViewBuilder
    private var expandContentsImage: some View {
        if let imageUrls = data.imageUrls, !imageUrls.isEmpty {
            ScrollView(.horizontal, content: {
                HStack(spacing: TipsContentsConstants.imageHspacing, content: {
                    ForEach(imageUrls.prefix(TipsContentsConstants.expandImageCount), id: \.self) { url in
                        makeImage(imageUrl: url)
                    }
                })
            })
        }
    }
    
    // MARK: - BottomContents
    /// 아래 게시글 작성 및 주인 표시
    private var bottomContents: some View {
        HStack(content: {
            bottomTipsInfo
            Spacer()
            moreInfoBtn
        })
    }
    
    /// 스크랩 및 본인 작성 여부에 따른 상태표시
    @ViewBuilder
    private var bottomTipsInfo: some View {
        switch tipsType {
        case .writeMyTips:
            myWriteTipsInfo
        case .scrapTips:
            scrapTipsInfo
        }
    }
    
    /// 본인 작성 시 상태 표시
    private var myWriteTipsInfo: some View {
        HStack(spacing: TipsContentsConstants.myWriteHspacing, content: {
            Text(data.createdAt.convertedToKoreanTimeDateString())
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            heartInfo
        })
    }
    
    /// 하트 정보 표시
    private var heartInfo: some View {
        HStack(spacing: TipsContentsConstants.heartHspacing, content: {
            Image(systemName: TipsContentsConstants.heartImage)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: TipsContentsConstants.heartImageSize.width, height: TipsContentsConstants.heartImageSize.height)
                .foregroundStyle(Color.gray600)
            
            Text((data.recommendCount ?? .zero) <= 999 ? "\(data.recommendCount ?? .zero)" : "999+")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray600)
        })
    }
    
    /// 스크랩 시 상태 표시
    private var scrapTipsInfo: some View {
        HStack(spacing: TipsContentsConstants.scrapHspacing, content: {
            Group {
                Text(data.authorName)
                Text(data.createdAt.timeAgoFromServerTime())
            }
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
        })
    }
    
    /// 더보기 및 접기 버튼 클릭
    private var moreInfoBtn: some View {
        Button(action: {
            withAnimation {
                isExpand.toggle()
            }
        }, label: {
            Text(isExpand.moreText)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
                .underline()
        })
    }
}

extension TipsContentsCard {
    /// 상단 태그 생성
    /// - Parameters:
    ///   - text: 태그 텍스트
    ///   - color: 태그 색상
    /// - Returns: 태그 컴포넌트 반환
    func makeTag(text: String, color: Color) -> some View {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray900)
            .frame(width: TipsContentsConstants.tagSize.width, height: TipsContentsConstants.tagSize.height)
            .padding(TipsContentsConstants.tagEdge)
            .background {
                RoundedRectangle(cornerRadius: TipsContentsConstants.cornerRadius)
                    .fill(color)
            }
    }
    
    /// 게시글 이미지 생성
    /// - Parameter imageUrl: 이미지 url
    /// - Returns: 이미지 뷰 반환
    @ViewBuilder
    func makeImage(imageUrl: String) -> some View {
        if let url = URL(string: imageUrl) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }
                .retry(maxCount: TipsContentsConstants.imageMaxCount, interval: .seconds(TipsContentsConstants.imageTime))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: TipsContentsConstants.imageSize.width, height: TipsContentsConstants.imageSize.height)
                .clipShape(RoundedRectangle(cornerRadius: TipsContentsConstants.cornerRadius))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: TipsContentsConstants.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray200, style: .init())
                })
        }
    }
    
    /// 이미지 남은 갯수 표시
    /// - Parameter count: 갯수
    /// - Returns: 이미지 반환
    func makeCountTag(count: Int) -> some View {
        ZStack {
            Image(.bottomRightTag)
                .fixedSize()
            Text("\(count)")
                .font(.Detail1_bold)
                .foregroundStyle(Color.white)
        }
    }
}
