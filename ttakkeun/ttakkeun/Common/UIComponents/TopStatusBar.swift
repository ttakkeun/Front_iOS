//
//  TopStatusBar.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct TopStatusBar: View {
    var body: some View {
        HStack {
            leftHStack()
            
            Spacer()
            
            rightHStack()
        }
        .frame(width: 353)
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
