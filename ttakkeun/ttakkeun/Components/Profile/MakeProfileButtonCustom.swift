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
    var leftAction: () -> Void
    var rightAction: () -> Void
    
    @State private var selectedButton: String? = nil
    
    //MARK: - Init
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
            Button(action: {
                leftAction()
                selectedButton = firstText
            }, label: {
                Text(firstText)
                    .frame(width: 165, height: 44)
                    .font(.Body3_medium)
                    .foregroundStyle(selectedButton == firstText ? Color.gray_900 : Color.gray_400)
                    .background(selectedButton == firstText ? Color.primarycolor_200 : Color.clear)
                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft]))
            })
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray_200)
            
            Button(action: {
                rightAction()
                selectedButton = secondText
            }, label: {
                Text(secondText)
                    .frame(width: 165, height: 44)
                    .font(.Body3_medium)
                    .foregroundStyle(selectedButton == secondText ? Color.gray_900 : Color.gray_400)
                    .background(selectedButton == secondText ? Color.primarycolor_200 : Color.clear)
                    .clipShape(RoundedCorner(radius: 10, corners: [.topRight, .bottomRight]))
            })
        })
        .frame(width:331, height: 44)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray_200, lineWidth: 1)
        )
    }
}

/// 버튼 한쪽만 radius 주기
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
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
