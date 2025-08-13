//
//  MainButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import SwiftUI

// FIXME: - Height 삭제 필요
struct MainButton: View {
    
    // MARK: - Property
    
    var btnText: String
    var height: CGFloat
    var action: () -> Void
    var color: Color
    
    // MARK: - Constants
    
    fileprivate enum MainButtonConstants {
        static let cornerRadius: CGFloat = 10
        static let bottomPadding: CGFloat = 20
    }
    
    // MARK: - Init
    /// Description
    /// - Parameters:
    ///   - btnText: 버튼 텍스트
    ///   - width: 가장 큰 버튼은 337 or 두개로 나뉘는 버튼은 208, 122
    ///   - height: 59
    ///   - action: {print("helloworld")} 이런식으로 작성
    ///   - color: .primaryColor_Main, .productCard_Color
    init(btnText: String,
         height: CGFloat = 53,
         action: @escaping () -> Void,
         color: Color
    ) {
        self.btnText = btnText
        self.height = height
        self.action = action
        self.color = color
    }
    
    // MARK: - Init
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: MainButtonConstants.cornerRadius)
                    .fill(color)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                
                Text(btnText)
                    .font(.Body2_semibold)
                    .foregroundStyle(Color.gray900)
            }
        })
        .padding(.bottom, MainButtonConstants.bottomPadding)
    }
}

struct MainButton_Preview: PreviewProvider {
    static var previews: some View {
        MainButton(btnText: "구매하러가기", height: 59, action: {print("hello")}, color: .mainPrimary)
            .previewLayout(.sizeThatFits)
    }
}
