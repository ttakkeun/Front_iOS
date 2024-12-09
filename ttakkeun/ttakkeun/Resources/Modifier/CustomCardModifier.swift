//
//  CustomCardModifier.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation
import SwiftUI

struct CustomCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.5))
                    .shadow03()
            }
            .transition(.blurReplace)
            
    }
}
