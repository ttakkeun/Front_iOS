//
//  HomeDragView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

/// 홈화면 드래그 뷰
struct HomeDragView: View {
    
    @State private var offset: CGFloat
    @State private var lastoffset: CGFloat
    @GestureState private var dragOffset: CGFloat = 0
    
    init() {
        _offset = State(initialValue: 0)
        _lastoffset = State(initialValue: 0)
    }
    
    // MARK: - Contents
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let minOffset: CGFloat = screenHeight * 0.67
            let maxOffset: CGFloat = screenHeight * 0.25
            
            /* 임계값을 두어 드래그뷰를 위 아래로 조절한다. */
            VStack {
                Capsule()
                    .fill(Color.gray_300)
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.yellow)
            .clipShape(.rect(topLeadingRadius: 30, topTrailingRadius: 30))
            .shadow03()
            .offset(y: offset + dragOffset)
            .gesture(
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
                    .onEnded({ value in
                        let threshold: CGFloat = 50
                        if value.translation.height < -threshold {
                            offset = maxOffset
                        } else {
                            offset = minOffset
                        }
                        lastoffset = offset
                    })
            )
            .onAppear {
                self.offset = maxOffset
            }
        }
        .animation(.interactiveSpring(), value: offset)
    }
    
    // MARK: - Components
    
//    // MARK: - Function
//    private func titleText(text: String) -> some View {
//        Text(text)
//            .font(.H4_bold)
//            .fore
//    }
    
}

struct HomeDragView_Preview: PreviewProvider {
    static var previews: some View {
        HomeDragView()
            .previewLayout(.sizeThatFits)
    }
}
