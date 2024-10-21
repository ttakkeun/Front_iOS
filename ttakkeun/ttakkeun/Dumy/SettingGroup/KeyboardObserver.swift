//
//  KeyboardObserver.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//
import SwiftUI
import Combine

/// 키보드 등장 시 하단 탭바 숨기기
class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        willShow
            .merge(with: willHide)
            .sink { [weak self] notification in
                if notification.name == UIResponder.keyboardWillShowNotification {
                    self?.isKeyboardVisible = true
                } else {
                    self?.isKeyboardVisible = false
                }
            }
            .store(in: &cancellables)
    }
}

