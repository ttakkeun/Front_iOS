//
//  RecommendProduct.swift
//  ttakkeun
//
//  Created by 한지강 on 8/20/24.
//

import SwiftUI
import Kingfisher


//TODO: - 이거 눌렀을때 ProductSheetView불러야 함.(데이터 전달해서 그대로 띄워야함)
/// 추천 탭 상품 컴포넌트
struct RecommendProduct: View {
    @State private var isLike: Bool
    @State private var totalLikes: Int
    
    let data: RecommenProductResponseData
    let rank: Int
    // MARK: - Init
    init(
        data: RecommenProductResponseData,
        rank: Int
    ) {
        self.data = data
        self.rank = rank
        
        _isLike = State(initialValue: data.isLike)
        _totalLikes = State(initialValue: data.total_likes)
    }
    
    // MARK: - Components
    var body: some View {
        HStack(spacing: 14) {
            imageAndRank
            titleAndPrice
        }
        .frame(maxWidth: 344, maxHeight: 95)
        .padding(.horizontal, 3)
    }
    
    /// 사진이미지와 순위
    private var imageAndRank: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            ZStack(alignment: .bottomLeading, content: {
                productImage
                rankTag
            })
        
        })
        
        .frame(width: 84, height: 150)
    }
    
    /// 상품이름과 상품가격
    private var titleAndPrice: some View {
        VStack(alignment: .leading) {
            title
                .padding(.bottom, 5)
            price
            heartBtn
        }
        .frame(maxWidth: 236, maxHeight: 95)
    }
    
    /// 순위 표시 태그
    @ViewBuilder
    private var rankTag: some View {
        ZStack {
            if (0...2).contains(rank) {
                Icon.topRank.image
                    .fixedSize()
            } else {
                Icon.bottomRank.image
                    .fixedSize()
            }
            Text("\(rank + 1)")
                .font(.suit(type: .bold, size: 10))
                .foregroundStyle(Color.white)
        }
    }
    
    //TODO: - 상품 이미지 받아와서 띄워야함
    /// 추천 상품 이미지
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("추천 제품 이미지 로당 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 95, maxHeight: 95)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray200, lineWidth: 1)
                )
                
            
        }
    }
    
    //TODO: - 상품이름 받아와서 텍스트 띄워야함
    /// 상품 이름
    private var title: some View {
        Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
            .font(.Body3_semibold)
            .foregroundStyle(Color.gray900)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    //TODO: - 가격받아서 띄워야 함
    /// 상품 가격
    private var price: some View {
        Text("\(data.price)원")
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
    }
    
    //TODO: - 하트 isLike(Bool)이랑, 하트수 totalNumber(Int)받아와서 띄워야 함, 그리고 누르면 patch로 하트수 변경할 수 있어야 함.
    // 하트 버튼과 하트 수
    private var heartBtn: some View {
        HStack{
            Spacer()
            Button(action: {
                isLike.toggle()
                totalLikes += isLike ? 1 : -1
            }, label: {
                HStack{
                    Image(systemName: isLike ? "heart.fill" : "heart")
                        .foregroundColor(isLike ? Color.red : Color.gray)
                    Text("\(totalLikes)")
                        .foregroundColor(isLike ? Color.red : Color.gray)
                }
            })
        }
    }
}

//MARK: - Components
struct RecommenProduct_Preview: PreviewProvider {
    static var previews: some View {
        RecommendProduct(data: RecommenProductResponseData(product_id: 1, title: "아껴주다 저자극 천연 복실복실 고양이 샴푸 500ml", image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg", price: 13000, brand: "지강", link: "https://smartstore.naver.com/main/products/7619827035", category1: "지강", category2: "지강", category3: "지강", category4: "지강", total_likes: 123, isLike: true), rank: 0)
            .previewLayout(.sizeThatFits)
    }
}
