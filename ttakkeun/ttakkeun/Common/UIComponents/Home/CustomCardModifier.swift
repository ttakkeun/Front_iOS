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
            .frame(width: 354, height: 260)
            .background(Color.white.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow03()
            .transition(.blurReplace)
    }
}
