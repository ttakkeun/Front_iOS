//
//  CustomNavigation.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

struct CustomNavigation: View {
    
    let action: () -> Void
    let title: String?
    let currentPage: Int?
    let naviIcon: Image
    let width: CGFloat
    let height: CGFloat
    
    /// Navigation Init
    /// - Parameters:
    ///   - action: 버튼 액션
    ///   - title: 네비게이션 내부 타이틀
    ///   - currentPage: 현재 페이지
    ///   - naviIcon: 네비게이션 아이콘
    init(
        action: @escaping () -> Void,
        title: String?,
        currentPage: Int? = nil,
        naviIcon: Image = Image(systemName: "xmark"),
        width: CGFloat = 14,
        height: CGFloat = 14
    ) {
        self.action = action
        self.title = title
        self.currentPage = currentPage
        self.naviIcon = naviIcon
        self.width = width
        self.height = height
    }
    
    var body: some View {
        HStack(alignment: .center, content: {
            Button(action: {
                action()
            }, label: {
                naviIcon
                    .resizable()
                    .frame(width: width, height: height)
                    .foregroundStyle(Color.black)
            })
            
            if let title = self.title {
                Spacer().frame(minWidth: 96, maxWidth: naviIcon == Image(systemName: "xmark") ? 98 : 103)
                
                Text(title)
                    .font(.H3_bold)
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: 132, alignment: .center)
                
            } else {
                Spacer()
            }
            
            if let currentPage = self.currentPage {
                
                Spacer().frame(maxWidth: 75)
                
                Text("\(currentPage) / 5")
                    .font(.Body2_semibold)
                    .foregroundStyle(Color.gray900)
            } else {
                Spacer()
            }
            
        })
        .frame(width: 353, height: 24)
    }
}

struct CustomNavigation_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavigation(action: { print("hello") }, title: "TIP 작성", currentPage: nil)
            
            Spacer()
        }
    }
}
