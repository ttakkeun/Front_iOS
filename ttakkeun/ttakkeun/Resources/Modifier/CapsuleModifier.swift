//
//  CapsuleModifier.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/20/24.
//

import Foundation
import SwiftUI

struct CapsuleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 4)
            .foregroundStyle(Color.gray400)
    }
}
