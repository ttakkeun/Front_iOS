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
            
            /*SheetView로 나올 때 화면이 잘리거나, 여백이 많은 경우가 생김*/
            
            Capsule()
                .fill(Color.gray_300)
                .frame(width: 38, height: 5)
                .padding(.top, 10)
            
            productImage
                .border(Color.gray_200)
            
            titleset
            
            MainButton(btnText: "구매하러가기", width: 342, height: 59, action: {print("hello")}, color: .primaryColor_Main)
            
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
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray_400)
            
            Spacer()
            
            Button(action:{ print("helloworld!")
            }, label: {
                Image(systemName: "square.and.arrow.up")
                .foregroundStyle(Color.gray_400)}
            )
        }
    }
    
    /// 타이틀
    private var title: some View {
        Text(data.title.split(separator: "").joined(separator: "\u{200B}"))
            .frame(maxWidth: 325, alignment: .leading)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray_900)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
    }
    
    /// 기업명
    private var mallname: some View {
        Text("\(data.mallName) >")
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_400)
    }
    
    /// 하트수와 가격
    private var productprice: some View {
        HStack{
            //하트버튼과 하트수
            Button(action: {
                print("하트누르기")}
                   , label: {
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Color.red)
                    Text("\(data.productHeartNum ?? 0)")
                        .foregroundStyle(Color.red)
                }
            })
            Spacer()
            //가격
            Text("\(data.lprice)원")
                .font(.H3_bold)
            
        }
        .frame(width: 342, height: 24)
}
    
    //MARK: - Preview
    struct ProductSheetView_Preview: PreviewProvider {
        static var previews: some View {
            ProductSheetView(data: RecommenProductResponseData(
                title: "피부병 아토비 각질 비듬 예방 아껴주다 저자극 천연 고양이 샴푸 500ml(고양이 비듬, 턱드름 관리)",
                image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg",
                lprice: 30000,
                mallName: "아껴주다",
                category2: "고양이 용품",
                category3: "미용목욕",
                category4: "샴푸, 린스",
                productHeartNum: 304
            ))
        }
    }
}
