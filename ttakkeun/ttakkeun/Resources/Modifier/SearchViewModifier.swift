//
//  SearchViewModifier.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import Foundation
import SwiftUI

struct SearchViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .safeAreaPadding(EdgeInsets(top: 0, leading: 21, bottom: 0, trailing: 21))
    }
}
