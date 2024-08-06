//
//  topStatusBar.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/18/24.
//

import SwiftUI

struct TopStatusBar: View {
    var body: some View {
        statusBar
    }
    
    // MARK: - Contents
    private var statusBar: some View {
        HStack {
            
            HStack(spacing: 2, content: {
                Text("따끈")
                    .font(.santokki(type: .regular, size: 24))
                    .foregroundStyle(Color.black)
                Icon.petFriends.image
                    .resizable()
                    .frame(width: 54, height: 38)
            })
            
            Spacer().frame(maxWidth: 180)
           
            HStack(spacing: 8, content: {
                Icon.alarm.image
                    .fixedSize()
                Icon.setting.image
                    .fixedSize()
            })
        }
        .frame(maxWidth: 353)
    }
}

#Preview {
    TopStatusBar()
}
