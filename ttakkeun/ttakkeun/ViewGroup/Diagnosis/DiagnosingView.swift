//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/10/24.
//

import SwiftUI

/// 진단하기 버튼 클릭 후, 진단 중 뷰
struct DiagnosingView: View {
    
    @ObservedObject var viewModel: DiagnosticResultViewModel
    
    var body: some View {
        loadingView
    }
    
    private var loadingView: some View {
        ZStack(content: {
            Icon.loadingBg.image
                .fixedSize()
            
            VStack(spacing: 24, content: {
                Text("진단 중......")
                    .font(.H2_semibold)
                    .foregroundStyle(Color.black)
                
                Icon.bubbleLogo.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 257, height: 168)
            })
        })
        .frame(maxHeight: .infinity, alignment: .top).ignoresSafeArea(.all)
    }
}
