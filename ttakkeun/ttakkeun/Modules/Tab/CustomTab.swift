//
//  CustomTab.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import SwiftUI

struct CustomTab: View {
    
    @Binding var selectedTab: TabCase
    
    var body: some View {
        HStack {
            ForEach(TabCase.allCases, id: \.rawValue) { tab in
                
                Spacer()
                
                makeTabButton(tab)
                
                Spacer()
                
            }
        }
        .frame(height: 90)
        .ignoresSafeArea(.all)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
        .padding(.horizontal)
    }
    
    private func makeTabButton(_ tab: TabCase) -> Button<some View> {
        return Button(action: {
            withAnimation(.spring) {
                selectedTab = tab
            }
        }, label: {
            VStack(spacing: 4, content: {
                Icon(rawValue: tab.rawValue)?.image
                    .renderingMode(.template)
                    .fixedSize()
                    .foregroundStyle(selectedTab == tab ? Color.gray900 : Color.gray400)
                
                Text(tab.toKorean())
                    .font(.Detail1_bold)
                    .foregroundStyle(selectedTab == tab ? Color.gray900 : Color.gray400)
            })
        })
    }
}

struct CustomTab_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            CustomTab(selectedTab: .constant(.home))
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
        
    }
}
