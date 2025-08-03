//
//  CustomModifier.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/9/25.
//

import Foundation
import SwiftUI

struct CustomToolBarModifier: ViewModifier {
    let title: String?
    let leadingAction: () -> Void
    let naviIcon: Image
    let currentPage: Int?
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        leadingAction()
                    }, label: {
                        naviIcon
                            .frame(width: width, height: height)
                            .foregroundStyle(Color.black)
                    })
                })
                
                if let title = title {
                    ToolbarItem(placement: .principal, content: {
                        Text(title)
                            .font(.H4_bold)
                            .foregroundStyle(Color.black)
                    })
                }
                
                if let currentPage = currentPage {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Text("\(currentPage) / 5")
                            .font(.Body2_semibold)
                            .foregroundStyle(Color.gray900)
                    })
                }
            }
    }
}

extension View {
    func customNavigation(title: String? = nil, leadingAction: @escaping () ->  Void, naviIcon: Image, currentPage: Int? = nil, width: CGFloat = 14, height: CGFloat = 14) -> some View {
        self.modifier(CustomToolBarModifier(title: title, leadingAction: leadingAction, naviIcon: naviIcon, currentPage: currentPage, width: width, height: height))
    }
}
