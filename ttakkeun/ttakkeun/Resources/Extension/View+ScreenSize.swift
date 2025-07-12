//
//  View+ScreenSize.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/11/25.
//

import Foundation
import SwiftUI

extension View {
    func getScreenSize() -> CGSize {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return windowScene.screen.bounds.size
    }
}
