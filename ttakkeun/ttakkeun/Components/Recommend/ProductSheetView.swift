//
//  gogo.swift
//  Practice
//
//  Created by 한지강 on 7/22/24.
//

import SwiftUI
import Kingfisher

//TODO: - RecommendProduct 눌렀을 때 sheet로 띄워야 함.
struct ProductSheetView: View {
    
    let data: RecommenProductResponseData
    
    @State private var isLike: Bool
    @State private var totalLikes: Int
    
    init(data: RecommenProductResponseData) {
        self.data = data
        _isLike = State(initialValue: data.isLike)
        _totalLikes = State(initialValue: data.total_likes)
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(spacing: 28){
            
            Capsule()
                .fill(Color.gray300)
                .frame(width: 38, height: 5)
                .padding(.top, 10)
            
            productImage
                .border(Color.gray200)
            
            titleset
            //TODO: - 버튼 눌렀을 때 상품페이지 링크로 넘어가야 함.
            MainButton(btnText: "구매하러가기", width: 342, height: 59, action: {
                // 상품 구매 페이지로 이동하는 로직 구현
                if let url = URL(string: data.link) {
                    UIApplication.shared.open(url)
                }
            }, color: .primaryColorMain)
            
        }
        .frame(maxWidth: 394)
    }
    
    /// 카테고리, 타이틀, 기업명, 하트, 가격 모음
    private var titleset: some View {
        VStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 9) {
                category
                title
                mallname
            }
            .frame(width: 342)
            
            productprice
        }
    }
    
    /// 이미지
    //TODO: - 상품이미지 데이터 받아와서 띄워야 함.
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder{
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("sheetView에 상품이미지 불러오기 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 312, height: 185)
        }
    }
    
    /// 카테고리
    //TODO: - 카테고리 받아와서 띄워야 함.
    private var category: some View {
        HStack {
            Text("\(data.category2) > \(data.category3) > \(data.category4)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.gray400)
            
            Spacer()
            
            //TODO: - 공유하기 버튼 기능 추가
            Button(action:{
                // 공유하기 기능 추가 로직 구현
                print("공유하기 버튼 클릭됨")
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color.gray400)
            })
        }
    }
    
    /// 타이틀
    //TODO: - 상품이름 받아서 띄워야 함.
    private var title: some View {
        Text(data.title)
            .frame(maxWidth: 325, alignment: .leading)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color.gray900)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    /// 기업명
    //TODO: - 기업이름 받아와서 띄워야 함.
    /// 기업이름
    private var mallname: some View {
        Text("\(data.brand) >")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color.gray900)
    }
    
    //TODO: - 상품가격 받아와서 띄워야 함.
    /// 상품가격
    private var productprice: some View {
        HStack{
            heartBtn
            Spacer()
            Text("\(data.price)원")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.gray900)
            
        }
        .frame(width: 342, height: 24)
    }
    
    //TODO: - 하트 isLike(Bool)이랑, 하트수 totalNumber(Int) 받아와서 띄워야 함, 그리고 누르면 patch로 하트수 변경할 수 있어야 함.
    // 하트 버튼과 하트 수
    private var heartBtn: some View {
        HStack{
            Button(action: {
                isLike.toggle()
                totalLikes += isLike ? 1 : -1
                // 여기에 서버와 통신하여 하트 상태를 업데이트하는 로직 추가 (PATCH 요청)
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

//MARK: - Preview
struct ProductSheetView_Preview: PreviewProvider {
    static var previews: some View {
        ProductSheetView(data: RecommenProductResponseData(
            product_id: 1,
            title: "피부병 아토비 각질 비듬 예방 아껴주다 저자극 천연 고양이 샴푸 500ml(고양이 비듬, 턱드름 관리)",
            image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg",
            price: 30000,
            brand: "아껴주다",
            link: "https://www.example.com",
            category1: "반려동물 용품",
            category2: "고양이 용품",
            category3: "미용목욕",
            category4: "샴푸, 린스",
            total_likes: 304,
            isLike: true
        ))
        .previewLayout(.sizeThatFits)
    }
}
