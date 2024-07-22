//
//  ButtonComponent.swift
//  ttakkeun
//
//  Created by 한지강 on 7/22/24.
//

import SwiftUI

struct MainButton: View {
    
    var btnText: String
    var width: CGFloat
    var height: CGFloat
    var action: Void
    var color: Color
    
    
    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - btnText: 버튼 텍스트
    ///   - width: 가장 큰 버튼은 337 or 두개로 나뉘는 버튼은 208, 122
    ///   - height: 59
    ///   - action: {print("helloworld")} 이런식으로 작성
    ///   - color: .yesBtn_Color or .noBtn_Color
    init(btnText: String,
         width: CGFloat,
         height: CGFloat,
         action: @escaping () -> Void,
         color: Color
    ) {
        self.btnText = btnText
        self.width = width
        self.height = height
        self.action = action()
        self.color = color
    }

    
    var body: some View {
        Button(action: {
            action
        }, label: {
            Text(btnText)
                .font()
                .foregroundStyle(Color.mainTextColor_Color)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .frame(width: width, height: height))
        })
        
        
    }
}


struct MainButton_Preview: PreviewProvider {
    static var previews: some View {
        MainButton(btnText: "구매하러가기", width: 337, height: 59, action: {print("hello")}, color: .yesBtn_Color)
    }
}
