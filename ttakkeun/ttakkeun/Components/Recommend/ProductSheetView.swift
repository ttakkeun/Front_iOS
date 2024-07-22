//
//  gogo.swift
//  Practice
//
//  Created by 한지강 on 7/22/24.
//


import SwiftUI

struct ProductSheetView: View {
//    let RecommenProductData: RecommenProductData
//
//    init(RecommenProductData: RecommenProductData) {
//        self.RecommenProductData = RecommenProductData
//    }
//
    var body: some View {
        VStack{
            productImage
            titleset
            purchaseset

        }
    }
    
    private var productImage: some View {
        Image(systemName: "square.and.arrow.up")
            .frame(width: 393, height: 287)
            .padding(14)
        //fixed, resize 어떻게?
        
    }
    
    
    
    private var titleset: some View {
        VStack(spacing: 8) {
            category
            title
            mallname
        }
        .frame(width: 342, height: 118)
    }
    
    
    private var purchaseset: some View {
        VStack(spacing: 20) {
            productprice
            purchaseBtn
        }
    }
    
    
    
    
    private var category: some View {
        HStack {
            Text("고양이 용품 > 미용목욕 > 샴푸 린스")
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(Color.gray)
        }
    }
    
    private var title: some View {
        HStack{
            Text("피부병 아토비 각질 비듬 예방 \n아껴주다 저자극 천연 고양이 샴푸 500ml\n (고양이 비듬, 턱드름 관리)\n")
            Spacer()
        }
    }
    
    private var mallname: some View {
        HStack{
            Text("아껴주다 >")
            Spacer()
        }
    }
    

    
    
    private var productprice: some View {
        HStack{
            Image(systemName: "heart.fill")
                .foregroundStyle(Color.red)
            Spacer()
            Text("13,000원")
        }
        .frame(width: 342, height: 24)
    }
    
    private var purchaseBtn: some View{
        Button(action: {
            print("구매하기")
        }, label: {
        Text("등록하기")
                .font(.suit(type: .semibold, size: 16))
                .foregroundStyle(Color.mainTextColor_Color)
                .frame(width: 318, height: 22)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yesBtn)
                    )
        }
               
        
        
        )
        
    }
    
    
}


struct ProductSheetView_Preview: PreviewProvider {
    static var previews: some View {
        ProductSheetView()

    }
}
