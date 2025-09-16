//
//  DownKeyboardModifier.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/3/25.
//

import SwiftUI

extension View {
    func keyboardToolbar(downAction: @escaping () -> Void) -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard, content: {
                HStack(content: {
                    Spacer()
                })
            })
            ToolbarItem(placement: .keyboard) {
                Button(action: {
                    downAction()
                }, label: {
                    Image(systemName: "chevron.down")
                        .renderingMode(.template)
                        .foregroundStyle(Color.gray900)
                })
            }
        }
    }
}
