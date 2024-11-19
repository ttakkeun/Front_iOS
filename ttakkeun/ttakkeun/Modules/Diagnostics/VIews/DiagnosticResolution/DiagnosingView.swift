//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import SwiftUI

/// 진단 중 화면
struct DiagnosingView: View {
    
    @ObservedObject var viewModel: DiagnosticResultViewModel
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Icon.diagnosingBg.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 24, content: {
                
                Spacer().frame(height: 220)
                
                ProgressView(label: {
                    LoadingDotsText(text: "AI가 데이터를 분석 중입니다... \n잠시만 기다려주세요! ")
                })
                
                Icon.bubbleLogo.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 257, height: 168)
                
                Spacer()
            })
        })
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all)
    }
}

struct DiagnosingView_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosingView(viewModel: DiagnosticResultViewModel())
    }
}
