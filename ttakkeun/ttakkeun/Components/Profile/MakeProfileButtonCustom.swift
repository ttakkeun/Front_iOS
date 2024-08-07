//
//  MakeProfileButtonCustom.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/29/24.
//

import SwiftUI

/// 프로필 생성뷰 토글 버튼(두 옵션 중에 하나 선택하는 버튼) 뷰
struct MakeProfileButtonCustom: View {
    
    var firstText: String
    var secondText: String
    var leftAction: () -> Void
    var rightAction: () -> Void
    
    @State private var selectedButton: String? = nil
    
    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - firstText: 왼쪽 버튼에 들어갈 텍스트
    ///   - secondText : 오른쪽 버튼에 들어갈 텍스트
    ///   - leftAction: 왼쪽 버튼 눌렀을 때 버튼 액션
    ///   - rightAction: 오른쪽 버튼 눌렀을 때 버튼 액션
    init(firstText: String,
         secondText: String,
         leftAction: @escaping () -> Void,
         rightAction: @escaping () -> Void
    ) {
        self.firstText = firstText
        self.secondText = secondText
        self.leftAction = leftAction
        self.rightAction = rightAction
    }
    
    //MARK: - Contents
    /// 버튼 구조
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            ///왼쪽 버튼
            Button(action: {
                leftAction()
                selectedButton = firstText
            }, label: {
                Text(firstText)
                    .frame(width: 165, height: 44)
                    .font(.Body3_medium)
                    .foregroundStyle(selectedButton == firstText ? Color.gray_900 : Color.gray_400)
                    .background {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 10))
                            .foregroundStyle(selectedButton == firstText ? Color.primarycolor_200 : Color.clear)
                    }
            })
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray_200)
            
            ///오른쪽 버튼
            Button(action: {
                rightAction()
                selectedButton = secondText
            }, label: {
                Text(secondText)
                    .frame(width: 165, height: 44)
                    .font(.Body3_medium)
                    .foregroundStyle(selectedButton == secondText ? Color.gray_900 : Color.gray_400)
                    .background {
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10))
                            .foregroundStyle(selectedButton == secondText ? Color.primarycolor_200 : Color.clear)
                    }
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
