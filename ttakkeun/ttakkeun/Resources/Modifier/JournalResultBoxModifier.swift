//
//  JournalResultBoxModifier.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import Foundation
import SwiftUI

struct JournalResultBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top, 20)
            .padding(.bottom, 24)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .stroke(Color.gray200, lineWidth: 1)
            }
    }
}
