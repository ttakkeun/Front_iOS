//
//  TipsSegment.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct TipsSegment: View {
    
    @ObservedObject var viewModel: TipsViewModel
    
    var body: some View {
        ScrollView(.horizontal, content: {
            HStack(spacing: 8, content: {
                ForEach(ExtendPartItem.orderedCases, id: \.self) { segment in
                    makeSegment(segment)
                }
            })
            .padding(.horizontal, 19)
            .padding(.vertical, 10)
        })
        .scrollIndicators(.hidden)
    }
    
    private func makeSegment(_ segment: ExtendPartItem) -> some View {
        Button(action: {
            withAnimation(.spring(duration: 0.2)) {
                viewModel.isSelectedCategory = segment
            }
        }, label: {
            Text(segment.toKorean())
                .frame(width: 40, height: 20)
                .font(.Body2_medium)
                .foregroundStyle(viewModel.isSelectedCategory == segment ? Color.gray900 : Color.gray600)
                .padding(.vertical, 6)
                .padding(.horizontal, 18)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(viewModel.isSelectedCategory == segment ? Color.primarycolor200 : Color.clear)
                        .stroke(Color.gray600, lineWidth: 1)
                }
        })
    }
}

struct TipsSegment_Preview: PreviewProvider {
    static var previews: some View {
        TipsSegment(viewModel: TipsViewModel())
    }
}
