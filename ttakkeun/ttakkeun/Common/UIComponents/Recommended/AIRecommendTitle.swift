//
//  AIRecommendTitle.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import SwiftUI

struct AIRecommendTitle: View {
    
    let padding: CGFloat
    let title: String
    
    init(padding: CGFloat, title: String) {
        self.padding = padding
        self.title = title
    }
    
    var body: some View {
        HStack(spacing: 4, content: {
            
            Icon.recommendDog.image
                .fixedSize()
            Text(title)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
        })
        .padding(.leading, padding)
    }
}
