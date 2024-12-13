//
//  ProductSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/27/24.
//

import SwiftUI
import Kingfisher
import UIKit

struct ProductSheetView: View {
    
    @State private var loadedImage: Image = Image(systemName: "questionmark.square.fill")
    @State private var isActivityViewPresented = false
    
    @Binding var data: ProductResponse
    @Binding var isShowSheet: Bool
    
    init(data: Binding<ProductResponse>, isShowSheet: Binding<Bool>) {
        self._data = data
        self._isShowSheet = isShowSheet
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 28, content: {
            Capsule()
                .modifier(CapsuleModifier())
            
            productImage
                .padding(.top, 6)
            
            productInfoGroup
                .padding(.top, 12)
            
            MainButton(btnText: "구매하러 가기", width: 342, height: 59, action: {
                openSite(data.purchaseLink)
            }, color: Color.mainPrimary)
        })
        .frame(width: 342, height: 544, alignment: .top)
        .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    }
    
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    Image(systemName: "questionmark.square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }.retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .frame(width: 300, height: 185)
                .aspectRatio(contentMode: .fill)
                .padding(10)
                .overlay(content: {
                    Rectangle()
                        .fill(Color.clear)
                        .stroke(Color.gray200, lineWidth: 1)
                })
        }
    }
    
    private var productInfoGroup: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            category
            productTitleInfo
            productPriceInfo
                .padding(.top, 9)
        })
        .frame(height: 145, alignment: .top)
    }
    
    private var category: some View {
        HStack(content: {
            Text(buildCategoryList())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray400)
            
            Spacer()
            
            ShareLink(
                items: [
                    "[따끈] \n\(data.title.split(separator: "").joined(separator: "\u{200B}"))",
                    data.purchaseLink
                ]
            ) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 23)
                    .foregroundStyle(Color.gray400)
            }
        })
    }
    
    private var productTitleInfo: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            Text(data.title)
                .frame(width: 323, alignment: .leading)
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
            
            Text(data.brand?.isEmpty == false ? "\(data.brand!) >" : "브랜드 정보 없음")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        })
    }
    
    private var productPriceInfo: some View {
        HStack(content: {
            LikeButton(data: $data)
            
            Spacer()
            
            Text("\(DataFormatter.shared.formattedPrice(from: data.price))원")
                .font(.H3_bold)
                .foregroundStyle(Color.gray900)
        })
    }
}

extension ProductSheetView {
    
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
                                                         likeStatus: true)), isShowSheet: .constant(true))
    }
}
