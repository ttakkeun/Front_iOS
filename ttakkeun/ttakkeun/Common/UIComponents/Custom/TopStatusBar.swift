//
//  TopStatusBar.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

/// 상단 로고 및 설정 창
struct TopStatusBar: View {
    
    // MARK: - Propertry
    @EnvironmentObject var container: DIContainer
    
    // MARK: - Constant
    fileprivate enum TopStatusConstants {
        static let leftHspacing: CGFloat = 2
        static let leftFontSize: CGFloat = 24
        static let leftImageWidth: CGFloat = 54
        static let leftImageHeight: CGFloat = 38
        
        static let rightHstack: CGFloat = 8
        
        static let leftLogoText: String = "따끈"
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            leftHstack
            Spacer()
            rightBtn
        }
    }
    
    /// 왼쪽 로고 영역
    private var leftHstack: some View {
        HStack(spacing: TopStatusConstants.leftHspacing, content: {
            Text(TopStatusConstants.leftLogoText)
                .font(.santokki(type: .regular, size: TopStatusConstants.leftFontSize))
                .foregroundStyle(Color.black)
            
            Image(.logo)
                .resizable()
                .frame(width: TopStatusConstants.leftImageWidth, height: TopStatusConstants.leftImageHeight)
        })
    }
    
    /// 오른쪽 옵션 버튼
    private var rightBtn: some View {
        Button(action: {
            container.navigationRouter.push(to: .myPage)
        }, label: {
            Image(.setting)
                .fixedSize()
        })
    }
}

#Preview {
    TopStatusBar()
}
