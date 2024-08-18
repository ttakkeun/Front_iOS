//
//  CustomTab.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import SwiftUI

struct CustomTab: View {
    
    @Binding var selectedTab: TabCase
    @StateObject var keyboardObserver: KeyboardObserver = KeyboardObserver()
    
    var body: some View {
        GeometryReader { geo in
            if !keyboardObserver.isKeyboardVisible {
                HStack {
                    ForEach(TabCase.allCases, id: \.rawValue) { tab in
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedTab = tab
                            }
                        }, label: {
                            VStack(spacing: 4, content: {
                                Icon(rawValue: tab.rawValue)?.image
                                    .renderingMode(.template)
                                    .fixedSize()
                                    .foregroundStyle(selectedTab == tab ? Color.gray_900 : Color.gray_400)
                                
                                Text(tab.toKorean())
                                    .font(.suit(type: .bold, size: 10))
                                    .foregroundStyle(selectedTab == tab ? Color.gray_900 : Color.gray_400)
                            })
                        })
                        
                        Spacer()
                    }
                }
                .frame(width: geo.size.width, height: 90)
                .ignoresSafeArea(.keyboard)
                .background(Color.white)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20))
                .shadow(color: .black.opacity(0.25), radius: 4.05, x: 0, y: -2)
                .position(x: geo.size.width / 2, y: geo.size.height - 10)
            }
        }
    }
}

struct CustomTab_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            CustomTab(selectedTab: .constant(.home))
                .background(Color.green)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
        
    }
}
