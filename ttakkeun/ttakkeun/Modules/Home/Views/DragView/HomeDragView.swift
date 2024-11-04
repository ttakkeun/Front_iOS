//
//  HomeDragView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeDragView: View {
    
    @State private var offset: CGFloat
    @State private var lastOffset: CGFloat
    @GestureState private var dragOffset: CGFloat = 0
    
    
    private var profileType: ProfileType
    
    init(profileType: ProfileType) {
        _offset = State(initialValue: 0)
        _lastOffset = State(initialValue: 0)
        self.profileType = profileType
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let minOffset: CGFloat = screenHeight * 0.43
            let maxOffset: CGFloat = screenHeight * 0.06
            
            /* 임계값을 두어 드래그뷰를 위 아래로 조절한다. */
            VStack(alignment: .center, spacing: 21) {
                Image(systemName: offset == minOffset ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 38, height: 15)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                
                Text("hello")
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
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
                        lastOffset = offset
                    })
            )
            .onAppear {
                self.offset = minOffset
            }
        }
        .animation(.interactiveSpring(), value: offset)
    }
}

struct HomeDragView_Previvew: PreviewProvider {
    static var previews: some View {
        HomeDragView(profileType: .cat)
    }
}
