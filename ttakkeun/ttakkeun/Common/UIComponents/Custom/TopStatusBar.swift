//
//  TopStatusBar.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct TopStatusBar: View {
    
    let showDivider: Bool
    
    init(showDivider: Bool = true) {
        self.showDivider = showDivider
    }
    
    var body: some View {
        VStack(spacing: 3, content: {
            HStack {
                leftHStack()
                
                Spacer()
                
                rightHStack()
            }
            .safeAreaPadding(EdgeInsets(top: 7, leading: 0, bottom: 0, trailing: 0))
            .frame(width: 353)
            
            if showDivider {
                Divider()
                    .background(Color.gray200)
                    .frame(height: 1)
            }
        })
    }
    
    private func leftHStack() -> HStack<some View> {
        return HStack(spacing: 2) {
            Text("따끈")
                .font(.santokki(type: .regular, size: 24))
                .foregroundStyle(Color.black)
            
            Icon.logo.image
                .resizable()
                .frame(width: 54, height: 38)
        }
    }
    
    private func rightHStack() -> HStack<some View> {
        return HStack(spacing: 8) {
            Icon.alarm.image
                .fixedSize()
            Icon.setting.image
                .fixedSize()
        }
    }
}

#Preview {
    TopStatusBar()
}
