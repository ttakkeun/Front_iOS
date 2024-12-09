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
        .frame(height: 95)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
        .shadow(color: .black.opacity(0.25), radius: 4.05, x: 0, y: -2)
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
            .padding(.bottom, 10)
        })
    }
}

#Preview {
    TabView()
}
