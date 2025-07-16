//
//  LoadingDotsText.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI

struct LoadingDotsText: View {    
    // MARK: - Property
    @State private var dotCount: Int
    let color: Color
    let text: String
    
    private let maxDots:Int = 5
    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    
    // MARK: - Init
    init(
        dotCount: Int = 0,
        text: String,
        color: Color = .white
    ) {
        self.dotCount = dotCount
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text + String(repeating: ".", count: dotCount))
            .multilineTextAlignment(.center)
            .lineSpacing(2.5)
            .font(.Body3_medium)
            .foregroundStyle(color)
            .onReceive(timer, perform: { _ in
                dotCount = (dotCount + 1) % (maxDots + 1)
            })
    }
}


struct LoadingProgress: View {
    let text: String
    
    var body: some View {
        VStack {
            Spacer()
            
            ProgressView(label: {
                Text(text)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.5)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.white)
            })
            .controlSize(.large)
            
            Spacer()
        }
    }
}
