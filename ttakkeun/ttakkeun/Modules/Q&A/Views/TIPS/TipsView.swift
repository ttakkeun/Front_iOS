//
//  TipsView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/4/24.
//

import SwiftUI

struct TipsView: View {
    
    @StateObject var viewModel: TipsViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            TipsSegment(viewModel: viewModel)
            
            tipContents
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19))
        
    }
    
    @ViewBuilder
    private var title: some View {
        if viewModel.isSelectedCategory == .all || viewModel.isSelectedCategory == .best {
            Text("🔥\(viewModel.isSelectedCategory.toKorean())")
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
        }
    }
    
    private var tipContents: some View {
        ScrollView(.vertical, content: {
            if !viewModel.tipsResponse.isEmpty {
                LazyVStack(alignment: .leading, spacing: 16, content: {
                    title
                    ForEach($viewModel.tipsResponse, id: \.self) { $data in
                        TipsContentsCard(data: $data, tipsType: .scrapTips, tipsButtonOption: TipsButtonOption(heartAction: { viewModel.toggleLike(for: data.tipId) }, scrapAction: { viewModel.toggleBookMark(for: data.tipId) }))
                    }
                })
                .padding(.bottom, 80)
            }
        })
    }
}

#Preview {
    TipsView()
}
