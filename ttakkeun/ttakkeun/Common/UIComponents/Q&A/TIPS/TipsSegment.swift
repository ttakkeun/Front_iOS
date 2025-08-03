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
        static let segmentTitleVertical: CGFloat = 6
        static let segmentTitleHorizon: CGFloat = 18
        static let scrollPadding: CGFloat = 12
        
        static let segmentSize: CGSize = .init(width: 76, height: 32)
        
        static let cornerRadius: CGFloat = 20
        static let segmentAnimationDuration: TimeInterval = 0.2
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, content: {
            HStack(spacing: TipsSegment.segmentHspacing, content: {
                ForEach(ExtendPartItem.orderedCases, id: \.self) { segment in
                    makeSegment(segment)
                }
            })
        })
        .scrollIndicators(.hidden)
        .contentMargins(.vertical, UIConstants.horizonScrollBottomPadding, for: .scrollContent)
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
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
                .frame(width: TipsSegment.segmentSize.width, height: TipsSegment.segmentSize.height)
            
            Text(segment.toKorean())
                .font(.Body2_medium)
                .foregroundStyle(viewModel.isSelectedCategory == segment ? Color.gray900 : Color.gray600)
                .padding(.horizontal, TipsSegment.segmentTitleHorizon)
        }
    }
}

struct TipsSegment_Preview: PreviewProvider {
    static var previews: some View {
        TipsSegment(viewModel: TipsViewModel(container: DIContainer()))
    }
}
