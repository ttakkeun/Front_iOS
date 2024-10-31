//
//  ProfileTwoButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI

struct ProfileTwoButton: View {
    
    @State private var selectedButton: String? = nil
    
    var firstButton: ButtonOption
    var secondButton: ButtonOption
    
    init(firstButton: ButtonOption, secondButton: ButtonOption) {
        self.firstButton = firstButton
        self.secondButton = secondButton
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            makeButton(button: firstButton)
                .background {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 10))
                        .foregroundStyle(selectedButton == firstButton.textTitle ? Color.primarycolor200 : Color.clear)
                }
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray200)
            
            makeButton(button: secondButton)
                .background {
                    UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 10, topTrailing: 10))
                        .foregroundStyle(selectedButton == secondButton.textTitle ? Color.primarycolor200 : Color.clear)
                }
        })
        .frame(width: 331, height: 44)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray200, lineWidth: 1)
        })
    }
    
    func makeButton(button: ButtonOption) -> Button<some View> {
        return Button(action: {
            button.action()
            selectedButton = button.textTitle
        }, label: {
            Text(button.textTitle)
                .frame(width: 165, height: 44)
                .font(.Body3_medium)
                .foregroundStyle(selectedButton == button.textTitle ? Color.gray900 : Color.gray400)
        })
    }
}

struct ButtonOption {
    let textTitle: String
    let action: () -> Void
}

struct ProfileTwoButton_Preview: PreviewProvider {
    static var previews: some View {
        ProfileTwoButton(firstButton: ButtonOption(textTitle: "예", action: { print("yes") } ), secondButton: ButtonOption(textTitle: "아니오", action: { print("no") }))
    }
}
