//
//  ProfileTwoButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI

struct ProfileTwoButton: View {
    
    // MARK: - Property
    @Binding var selectedButton: String?
    
    var firstButton: ButtonOption
    var secondButton: ButtonOption
    
    // MARK: - Constants
    fileprivate enum ProfileTowButtonConstants {
        static let cornerRadius: CGFloat = 10
        static let dividerWidth: CGFloat = 1
        static let dividerHeight: CGFloat = 44
    }
    
    // MARK: - Init
    init(selectedButton: Binding<String?>, firstButton: ButtonOption, secondButton: ButtonOption) {
        self._selectedButton = selectedButton
        self.firstButton = firstButton
        self.secondButton = secondButton
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center, spacing: .zero, content: {
            makeButton(button: firstButton)
                .background {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: ProfileTowButtonConstants.cornerRadius, bottomLeading: ProfileTowButtonConstants.cornerRadius))
                        .foregroundStyle(selectedButton == firstButton.textTitle ? Color.primarycolor200 : Color.clear)
                }
            
            Divider()
                .frame(width: ProfileTowButtonConstants.dividerWidth, height: ProfileTowButtonConstants.dividerHeight)
                .background(Color.gray200)
            
            makeButton(button: secondButton)
                .background {
                    UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: ProfileTowButtonConstants.cornerRadius, topTrailing: ProfileTowButtonConstants.cornerRadius))
                        .foregroundStyle(selectedButton == secondButton.textTitle ? Color.primarycolor200 : Color.clear)
                }
        })
        .overlay(content: {
            RoundedRectangle(cornerRadius: ProfileTowButtonConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray200, style: .init())
        })
    }
    
    /// 왼쪽 오른쪽 버튼 생성을 위한 함수
    /// - Parameter button: 첫, 두 번째 버튼 옵션
    /// - Returns: 버튼 뷰 반환
    func makeButton(button: ButtonOption) -> Button<some View> {
        return Button(action: {
            button.action()
            selectedButton = button.textTitle
        }, label: {
            Text(button.textTitle)
                .frame(maxWidth: .infinity)
                .frame(height: ProfileTowButtonConstants.dividerHeight)
                .font(.Body3_medium)
                .foregroundStyle(selectedButton == button.textTitle ? Color.gray900 : Color.gray400)
        })
    }
}
