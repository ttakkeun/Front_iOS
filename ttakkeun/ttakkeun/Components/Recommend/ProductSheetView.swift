//
//  gogo.swift
//  Practice
//
//  Created by 한지강 on 7/22/24.
//


import SwiftUI
import Kingfisher

struct ProductSheetView: View {
    
    let data: RecommenProductResponseData
    
    init(data: RecommenProductResponseData) {
        self.data = data
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(spacing: 28){
            
            Capsule()
                .fill(Color.gray)
                .frame(width: 38, height: 5)
                .padding(.top, 10)
            
            productImage
                .border(Color.gray)
            
            titleset
            
            MainButton(btnText: "구매하러가기", width: 342, height: 59, action: {
                print("구매하기 버튼 클릭됨")
            }, color: .blue)
            
            Spacer()
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
    @ViewBuilder
    private var productImage: some View {
        if let url = URL(string: data.image) {
            KFImage(url)
                .placeholder{
                    ProgressView()
                        .frame(width: 100,height: 100)
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
    private var category: some View {
        HStack {
            Text("\(data.category2) > \(data.category3) > \(data.category4)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.gray)
            
            Spacer()
            
            Button(action:{
                print("공유하기 버튼 클릭됨")
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color.gray)
            })
        }
    }
    
    /// 타이틀
    private var title: some View {
        Text(data.title)
            .frame(maxWidth: 325, alignment: .leading)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color.black)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    /// 기업명
    private var mallname: some View {
        Text("\(data.brand) >")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color.gray)
    }
    
    /// 하트수와 가격
    private var productprice: some View {
        HStack{
            //하트버튼과 하트수
            Button(action: {
                print("하트 버튼 클릭됨")
            }, label: {
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.red)
                    Text("\(data.total_likes)")
                        .foregroundColor(Color.red)
                }
            })
            Spacer()
            //가격
            Text("\(data.price)원")
                .font(.system(size: 18, weight: .bold))
            
        }
        .frame(width: 342, height: 24)
    }
}

//MARK: - Preview
struct ProductSheetView_Preview: PreviewProvider {
    static var previews: some View {
        let sampleProduct = RecommenProductResponseData(
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
        )

        let sampleResponse = ResponseData(
            isSuccess: true,
            code: "200",
            message: "Success",
            result: sampleProduct
        )

        ProductSheetView(data: sampleResponse.result!)
            .previewLayout(.sizeThatFits)
    }
}
