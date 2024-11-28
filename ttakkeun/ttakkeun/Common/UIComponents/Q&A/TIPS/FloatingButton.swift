//
//  FloatingButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct FloatingButton: View {
    
    @Binding var isShowFloating: Bool
    
    @State private var selectedFloatingMenu: ExtendPartItem? = nil
    @Namespace var aniamtion
    let positionX: CGFloat = 0.85
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .trailing) {
                    if isShowFloating {
                        floatingList(geo: geo)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    floatingButton
                }
                .frame(width: 120, height: 430, alignment: .bottomTrailing)
                .position(x: geo.size.width * 0.8, y: geo.size.height * 0.7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
            .background(isShowFloating ? Color.btnBg.opacity(0.6) : Color.clear)
            .onTapGesture {
                withAnimation {
                    isShowFloating.toggle()
                }
            }
        }
    }
    
    private var floatingButton: some View {
        Button(action: {
            withAnimation(.spring(duration: 0.3)) {
                isShowFloating.toggle()
            }
        }, label: {
            Image(systemName: isShowFloating ? "xmark" : "plus")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: returnSize(), height: returnSize())
                .padding(16)
                .background {
                    Circle()
                        .fill(isShowFloating ? Color.white : Color.floatingBtn)
                        .shadow03()
                }
        })
    }
}

extension FloatingButton {
    func floatingList(geo: GeometryProxy) -> some View {
        VStack(spacing: 13, content: {
            ForEach(ExtendPartItem.floatingCases.reversed(), id: \.self) { segment in
                Button(action: {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedFloatingMenu = segment
                        isShowFloating.toggle()
                    }
                }, label: {
                    FloatingCategory(floatingCategory: segment)
                })
            }
        })
        .matchedGeometryEffect(id: "floating", in: aniamtion)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    func returnSize() -> CGFloat {
        if isShowFloating {
            return 15
        } else {
            return 18
        }
    }
}

struct FloatingButton_Preview: PreviewProvider {
    
    @State static var isShowFloating: Bool = false
    
    static var previews: some View {
        FloatingButton(isShowFloating: $isShowFloating)
    }
}
