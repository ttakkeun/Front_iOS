//
//  DiagnosisTopbutton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

/// 일지 상단 버튼
struct DiagnosisTopbutton: View {
    
    @ObservedObject var viewModel: DiagnosisViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    /// 돋보기 + 선택 버튼
    private var topButton: some View {
        Text("선택")
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_900)
            .padding(.horizontal, 21)
            .padding(.vertical, 8)
    }
}
