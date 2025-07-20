//
//  LoadingOverlay.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/10/25.
//

import Foundation
import SwiftUI

struct LoadingOverlayModifier: ViewModifier {
    
    let isLoading: Bool
    let loadingTextType: LoadingTextType
    
    fileprivate enum LoadingOverlayConstants {
        static let opacity: Double = 0.8
    }
    
    /// 로딩 텍스트 타입
    enum LoadingTextType: String {
        /// 프로필 생성 시 사용
        case createProfile = "반려동물 프로필 생성 중입니다."
        case createJournal = "일지 생성 중입니다. \n잠시 기다려주세요"
    }
    
    init(isLoading: Bool, loadingTextType: LoadingTextType) {
        self.isLoading = isLoading
        self.loadingTextType = loadingTextType
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                if isLoading {
                    ZStack {
                        Color.black.opacity(LoadingOverlayConstants.opacity)
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        ProgressView(label: {
                            LoadingDotsText(text: loadingTextType.rawValue)
                        })
                        .tint(Color.white)
                        .controlSize(.large)
                    }
                }
            })
    }
}

extension View {
    func loadingOverlay(isLoading: Bool, loadingTextType: LoadingOverlayModifier.LoadingTextType) -> some View {
        self.modifier(LoadingOverlayModifier(isLoading: isLoading, loadingTextType: loadingTextType))
    }
}
