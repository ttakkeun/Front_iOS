//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/8/24.
//

import SwiftUI

struct DiagnosingView: View {
    
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
    DiagnosingView()
}
