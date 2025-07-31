//
//  TipsSegment.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

/// 꿀팀 세그먼트 버튼
struct TipsSegment: View {
    
    // MARK: - Property
    @Bindable var viewModel: TipsViewModel
    
    // MARK: - Constants
    fileprivate enum TipsSegment {
        static let segmentHspacing: CGFloat = 8
        static let segmentVertical: CGFloat = 10
        static let cornerRadius: CGFloat = 20
        static let segmentAnimationDuration: TimeInterval = 0.2
        static let segmentTitleVertical: CGFloat = 6
        static let segmentTitleHorizon: CGFloat = 18
        static let segmentMaxHeight: CGFloat = 32
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, content: {
            HStack(spacing: TipsSegment.segmentHspacing, content: {
                ForEach(ExtendPartItem.orderedCases, id: \.self) { segment in
                    makeSegment(segment)
                }
            })
            .padding(.vertical, TipsSegment.segmentVertical)
        })
        .scrollIndicators(.hidden)
    }
    
    /// 세그먼트 생성 함수
    /// - Parameter segment: 세그먼트 타입
    /// - Returns: 세그먼트 버튼반환
    private func makeSegment(_ segment: ExtendPartItem) -> some View {
        Button(action: {
            withAnimation(.spring(duration: TipsSegment.segmentAnimationDuration)) {
                viewModel.isSelectedCategory = segment
            }
        }, label: {
            segmentComponent(segment)
        })
    }
    
    /// 세그먼트 버튼 개별 컴포넌트
    /// - Parameter segment: 세그먼트 타입
    /// - Returns: 세그먼트 버튼
    private func segmentComponent(_ segment: ExtendPartItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: TipsSegment.cornerRadius)
                .fill(viewModel.isSelectedCategory == segment ? Color.primarycolor200 : Color.clear)
                .stroke(Color.gray600, style: .init())
                .frame(maxWidth: .infinity, maxHeight: TipsSegment.segmentMaxHeight)
            
            Text(segment.toKorean())
                .font(.Body2_medium)
                .foregroundStyle(viewModel.isSelectedCategory == segment ? Color.gray900 : Color.gray600)
                .padding(TipsSegment.segmentTitleVertical)
                .padding(TipsSegment.segmentTitleHorizon)
        }
    }
}

struct TipsSegment_Preview: PreviewProvider {
    static var previews: some View {
        TipsSegment(viewModel: TipsViewModel(container: DIContainer()))
    }
}
