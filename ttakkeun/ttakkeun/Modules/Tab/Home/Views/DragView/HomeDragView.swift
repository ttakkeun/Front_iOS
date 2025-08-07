//
//  HomeDragView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeDragView: View {
    
    // MARK: - Property
    @State private var hasAppeared = false
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
    @GestureState private var dragOffset: CGFloat = .zero
    
    @State var homeRecommendViewModel: HomeRecommendViewModel
    @State var homeTodoViewModel: HomeTodoViewModel
    let petType: ProfileType
    
    // MARK: - Constants
    fileprivate enum HomeDragConstants {
        
        static let indicatorWidth: CGFloat = 40
        static let indicatorHeight: CGFloat = 5
        
        static let minScreenHeight: CGFloat = 0.345
        static let maxScreenHeight: CGFloat = 0.058
        
        static let compactComponentVspacing: CGFloat = 24
        static let cornerRadius: CGFloat = 30
        static let threshold: CGFloat = 5
        static let safeTopPadding: CGFloat = 8
        
        static let indicatorUpText: String = "chevron.up"
        static let indicatorDownText: String = "chevron.down"
    }
    
    // MARK: - Init
    init(container: DIContainer, petType: ProfileType) {
        self.homeRecommendViewModel = .init(container: container)
        self.homeTodoViewModel = .init(container: container)
        self.petType = petType
    }
    
    // MARK: - Body
    var body: some View {
        let screenHeight = getScreenSize().height
        let minOffset: CGFloat = screenHeight * HomeDragConstants.minScreenHeight
        let maxOffset: CGFloat = screenHeight * HomeDragConstants.maxScreenHeight
        let midPoint = (minOffset + maxOffset) / 2
        
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: HomeDragConstants.compactComponentVspacing, content: {
                HomeTodo(viewModel: homeTodoViewModel)
                HomeAIProduct(viewModel: homeRecommendViewModel)
                HomeTop(viewModel: homeRecommendViewModel, petType: petType)
            })
        })
        .contentMargins(.bottom, UIConstants.safeBottom, for: .scrollContent)
        .safeAreaInset(edge: .top, spacing: UIConstants.capsuleSpacing, content: {
            dragIndicator
        })
        .safeAreaPadding(.top, HomeDragConstants.safeTopPadding)
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: HomeDragConstants.cornerRadius, topTrailingRadius: HomeDragConstants.cornerRadius)
                .fill(Color.white)
                .ignoresSafeArea()
        }
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        // TODO: : task 작성 필요 데이터 조회 데이터
        .offset(y: offset + dragOffset)
        .gesture(dragGesture(minOffset: minOffset, maxOffset: maxOffset, midPoint: midPoint))
        .task {
            await initializeOffset(screenHeight: screenHeight, minOffset: minOffset)
        }
    }
    
    
    // MARK: TopContents
    /// 상단 인디케이터
    /// - Parameter minOffset: 높이 조절에 따른 인디케이터 조절
    /// - Returns: 뷰 반환
    private var dragIndicator: some View {
        Capsule()
            .fill(Color.gray)
            .frame(width: HomeDragConstants.indicatorWidth, height: HomeDragConstants.indicatorHeight)
    }
    
    // MARK: - BottomContents
    
    private func dragGesture(minOffset: CGFloat, maxOffset: CGFloat, midPoint: CGFloat) -> some Gesture {
        DragGesture()
            .updating($dragOffset, body: { value, state, _ in
                let newOffset = offset + value.translation.height
                if newOffset > minOffset {
                    state = minOffset - offset
                } else if newOffset < maxOffset {
                    state = maxOffset - offset
                } else {
                    state = value.translation.height
                }
            })
            .onEnded { value in
                let dragAmount = value.translation.height
                offset += dragAmount
                offset = offset.clamped(to: maxOffset...minOffset)
                
                let threshold: CGFloat = HomeDragConstants.threshold
                withAnimation(.easeInOut(duration: 0.4)) {
                    if dragAmount < -threshold {
                        offset = maxOffset
                    } else if dragAmount > threshold {
                        offset = minOffset
                    } else {
                        offset = (lastOffset < midPoint) ? maxOffset : minOffset
                    }
                }
                lastOffset = offset
            }
    }
    
    @MainActor
    private func initializeOffset(screenHeight: CGFloat, minOffset: CGFloat) async {
        if !hasAppeared {
            hasAppeared = true
            
            offset = screenHeight
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            withAnimation(.spring(response: 1.4, dampingFraction: 0.8)) {
                offset = minOffset
            }
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    HomeDragView(container: DIContainer(), petType: .cat)
}

#Preview("Home") {
    HomeView(container: DIContainer())
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
