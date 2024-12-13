//
//  LoadingDotsText.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI

struct LoadingDotsText: View {
    
    @State private var dotCount: Int
    let text: String
    
    private let maxDots:Int = 5
    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    
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
            .foregroundStyle(Color.gray900)
            .onReceive(timer, perform: { _ in
                dotCount = (dotCount + 1) % (maxDots + 1)
            })
    }
}
