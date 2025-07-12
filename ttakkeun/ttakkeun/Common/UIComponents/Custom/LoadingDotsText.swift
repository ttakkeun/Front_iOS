//
//  LoadingDotsText.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI

// FIXME: - 삭제
struct LoadingDotsText: View {
    
    // MARK: - Property
    @State private var dotCount: Int
    let text: String
    
    private let maxDots:Int = 5
    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    
    // MARK: - Init
    init(
        dotCount: Int = 0,
        text: String
    ) {
        self.dotCount = dotCount
        self.text = text
    }
    
    var body: some View {
        Text(text + String(repeating: ".", count: dotCount))
            .multilineTextAlignment(.center)
            .lineSpacing(2.5)
            .font(.Body3_medium)
            .foregroundStyle(Color.white)
            .onReceive(timer, perform: { _ in
                dotCount = (dotCount + 1) % (maxDots + 1)
            })
    }
}
