//
//  hideKeyboard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import Foundation
import SwiftUI

// FIXME: - 삭제 필요
extension UIApplication {
    func hideKeyboard() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            guard let window = windowScene.windows.first else { return }
            let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
            tapRecognizer.cancelsTouchesInView = false
            tapRecognizer.delegate = self
            window.addGestureRecognizer(tapRecognizer)
        }
    }
}

extension UIApplication: @retroactive UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

