//
//  MakeProfileButtonCustom.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/29/24.
//

import SwiftUI

struct MakeProfileButtonCustom: View {
    
    var firstText: String
    var secondText: String
    var leftAction: Void
    var rightAction: Void
    
    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - firstText : 왼쪽버튼 텍스트
    ///   - secondeText : 오른쪽버튼 텍스트
    ///   - width: 각 버튼 당 165
    ///   - height: 각 버튼 당 44
    ///   - action: {print("helloworld")} 이런식으로 작성
    ///   - color: .gray_200, .gray_400
    init(firstText: String,
         secondText: String,
         leftAction: @escaping () -> Void,
         rightAction: @escaping () -> Void
    ) {
        self.firstText = firstText
        self.secondText = secondText
        self.leftAction = leftAction()
        self.rightAction = rightAction()
    }
    
    //MARK: - Contents
    /// 버튼 구조
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Button(action: {
                leftAction
            }, label: {
                Text(firstText)
                    .frame(width: 165, height: 44)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_400)
                    .overlay(
                        UnevenRoundedRectangle()
                            .clipShape(.rect(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0))
                            .foregroundStyle(Color.clear)
                    )
            })
            
            Divider()
                .frame(width:1, height: 44)
                .background(Color.gray_200)
            
            Button(action: {
                rightAction
            }, label: {
                Text(secondText)
                    .frame(width: 165, height: 44)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_400)
                    .overlay(
                        UnevenRoundedRectangle()
                            .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
                            .foregroundStyle(Color.clear)
                    )
            })
        })
        .frame(width:331, height: 44)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray_200, lineWidth: 1)
        )
    }
}

//MARK: - Preiview
struct MakeProfileButtonCustom_Preview: PreviewProvider {
    static var previews: some View {
        MakeProfileButtonCustom(firstText: "강아지", secondText: "고양이", leftAction: {
            print("left")
        }, rightAction: {
            print("right")
        })
    }
}

