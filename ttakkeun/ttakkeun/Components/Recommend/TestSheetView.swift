//
//  TestSheetView.swift
//  ttakkeun
//
//  Created by 한지강 on 7/22/24.
//

import SwiftUI

struct TestSheetView: View {
    
    @State var showSheet:Bool = false
    
    var body: some View {
        Button(action: {
            self.showSheet = true
        }, label: {
            Text("클릭하세요")
        })
        .sheet(isPresented: $showSheet, content: {
            ProductSheetView(data: RecommenProductResponseData(
                title: "피부병 아토비 각질 비듬 예방 아껴주다 저자극 천연 고양이 샴푸 500ml(고양이 비듬, 턱드름 관리)",
                image: "https://shopping-phinf.pstatic.net/main_3596342/35963422008.jpg",
                lprice: 13000,
                mallName: "아껴주다",
                category2: "고양이 용품",
                category3: "미용목욕",
                category4: "샴푸, 린스",
                productHeartNum: 304
                ))
            .presentationCornerRadius(30)
            .presentationDetents([.medium,.large])
            .presentationDragIndicator(.hidden)
        })
       
    }
}

#Preview {
    TestSheetView()
}
