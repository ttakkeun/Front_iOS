//
//  Diagnostic images.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/6/24.
//

import SwiftUI

struct Diagnostic_images: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    // MARK: - Contents
    
    private var imageTitle: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("사진을 등록해주사면 \n따끈 AI 진단에서 더 정확한ㄴ 결과를 받을 수 있어요")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_900)
            
            Text("최대 5장")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray_400)
        }
        
    }
}

#Preview {
    Diagnostic_images()
}
