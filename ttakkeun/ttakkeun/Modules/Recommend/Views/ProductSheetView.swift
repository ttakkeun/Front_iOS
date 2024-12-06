//
//  ProductSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct ProductSheetView: View {
    
    @Binding var data: ProductResponse
    @Binding var isShowSheet: Bool
    
    init(data: Binding<ProductResponse>, isShowSheet: Binding<Bool>) {
        self._data = data
        self._isShowSheet = isShowSheet
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            Capsule()
                .modifier(CapsuleModifier())
            
            Spacer().frame(height: 36)
            
            productImage
            
            Spacer().frame(height: 40)
            
            productInfoGroup
            
            Spacer().frame(height: 28)
            
            MainButton(btnText: "구매하러 가기", width: 342, height: 59, action: {
                isShowSheet = false
                openSite(data.purchaseLink)
            }, color: Color.mainPrimary)
        })
        .frame(width: 342)
        .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .clipShape(.rect(topLeadingRadius: 10, topTrailingRadius: 10))
    }
    
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: 2, interval: .seconds(2))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 312, height: 185)
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
            
            Spacer().frame(height: 10)
            
            productPriceInfo
        })
    }
    
    private var category: some View {
        HStack(content: {
            Text(buildCategoryList())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray400)
            
            Spacer()
            
            ShareLink(item: data.purchaseLink,
                      preview: SharePreview("\(data.title)", image: loadImage(from: data.image)),
                      label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 23)
                    .foregroundStyle(Color.gray400)
            })
        })
    }
    
    private var productTitleInfo: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            Text(data.title)
                .frame(width: 323)
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
            
            if let brand = data.brand {
                Text("\(brand) >")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
            }
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
    func loadImage(from urlString: String) -> Image {
        guard let url = URL(string: urlString),
              let imageData = try? Data(contentsOf: url),
              let uiImage = UIImage(data: imageData) else {
            return Image(systemName: "photo")
        }
        return Image(uiImage: uiImage)
    }
    
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
