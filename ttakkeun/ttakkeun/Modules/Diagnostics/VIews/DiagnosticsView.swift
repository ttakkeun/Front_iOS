//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

/// 진단 목록 및 진단결과
struct DiagnosticsView: View {
    
    @StateObject var viewModel: DiagnosingViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            TopStatusBar()
            
            DiagnosingHeader(diagnosingValue: $viewModel.diagnosingValue)
            
            DiagnosingActionBar(viewModel: viewModel.journalListViewModel)
                
            Spacer()
            
        })
    }
}

#Preview {
    DiagnosticsView()
}
