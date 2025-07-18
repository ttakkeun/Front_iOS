//
//  ProductSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/27/24.
//

import SwiftUI
import Kingfisher
import UIKit

/// 상품 클릭 시 sheet 뷰
struct ProductSheetView: View {
    
    // MARK: - Property
    @Binding var data: ProductResponse
    let action: () -> Void
    
    // MARK: - Constant
    fileprivate enum ProductSheetConstants {
        static let imageVerticalPadding: CGFloat = 12
        static let contentsVspacing: CGFloat = 28
        static let middleContentsVspacing: CGFloat = 9
        static let lineSpacing: CGFloat = 2
        
        static let imageHeight: CGFloat = 185
        static let shareImageWidth: CGFloat = 20
        static let shareImageHeight: CGFloat = 23
        static let buttonHeight: CGFloat = 59
        
        
        static let imageSize: CGFloat = 30
        static let imageMaxCount: Int = 2
        static let imageTime: TimeInterval = 2
        
        static let loadImage: String = "questionmark.square.fill"
        static let shareImage: String = "square.and.arrow.up"
        static let buttonText: String = "구매하러 가기"
    }
    
    // MARK: - Init
    init(data: Binding<ProductResponse>, action: @escaping () -> Void) {
        self._data = data
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: ProductSheetConstants.contentsVspacing, content: {
            Capsule()
                .modifier(CapsuleModifier())
            productImage
            middleContents
            MainButton(btnText: ProductSheetConstants.buttonText, height: ProductSheetConstants.buttonHeight, action: {
                openSite(data.purchaseLink)
            }, color: Color.mainPrimary)
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    // MARK: - TopContents
    /// 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    Image(systemName: ProductSheetConstants.loadImage)
                        .resizable()
                        .frame(width: ProductSheetConstants.imageSize, height: ProductSheetConstants.imageSize)
                }.retry(maxCount: ProductSheetConstants.imageMaxCount, interval: .seconds(ProductSheetConstants.imageTime))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, ProductSheetConstants.imageVerticalPadding)
                .frame(maxWidth: .infinity)
                .frame(height: ProductSheetConstants.imageHeight)
                .border(Color.gray200)
        }
    }
    
    // MARK: - MiddleContents
    /// 중간 상품 정보
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: ProductSheetConstants.middleContentsVspacing, content: {
            category
            productTitleInfo
            productPriceInfo
                .padding(.top, 9)
        })
        .frame(height: 145, alignment: .top)
    }
    
    /// 상단 카테고리 및 쉐어링크
    private var category: some View {
        HStack(content: {
            Text(buildCategoryList())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray400)
            
            Spacer()
            
            ShareLink(
                items: [
                    "[따끈] \n\(data.title.customLineBreak())",
                    data.purchaseLink
                ]
            ) {
                Image(systemName: ProductSheetConstants.shareImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ProductSheetConstants.shareImageWidth, height: ProductSheetConstants.shareImageHeight)
                    .foregroundStyle(Color.gray400)
            }
        })
    }
    
    /// 상품 타이틀 정보
    private var productTitleInfo: some View {
        VStack(alignment: .leading, spacing: ProductSheetConstants.middleContentsVspacing, content: {
            Text(data.title)
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(ProductSheetConstants.lineSpacing)
            
            Text(data.brand?.isEmpty == false ? "\(data.brand!) >" : "브랜드 정보 없음")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        })
    }
    
    /// 좋아요 및 가격 정보
    private var productPriceInfo: some View {
        HStack(content: {
            LikeButton(data: $data, action: action )
            
            Spacer()
            
            Text("\(data.price)원")
                .font(.H3_bold)
                .foregroundStyle(Color.gray900)
        })
    }
}

extension ProductSheetView {
    /// 카테고리 연결 함수
    /// - Returns: 연결된 카테고리 값
    func buildCategoryList() -> String {
        [data.category2, data.category3, data.category4]
            .compactMap { $0 }
            .joined(separator: " > ")
    }
    
    func openSite(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

struct ProductSheet_Preview: PreviewProvider {
    static var previews: some View {
        ProductSheetView(data: .constant(ProductResponse(productId: 1,
                                                         title: "피부병 아토비 각질 비듬 예방 아껴주다 저자극 천연 고양이 샴푸 500ml(고양이 비듬, 턱드름 관리)",
                                                         image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg",
                                                         price: 30000,
                                                         brand: "쿠팡",
                                                         purchaseLink: "https://www.naver.com",
                                                         category1: "반려동물 용품",
                                                         category2: "고양이 용품",
                                                         category3: "미용목욕",
                                                         category4: "샴푸, 린스",
                                                         totalLike: 304,
                                                         likeStatus: true)), action: { print("hello!!@!@!@!") })
    }
}
