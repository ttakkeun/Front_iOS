//
//  FloatingBtn.swift
//  ttakkeun
//
//  Created by 한지강 on 8/8/24.
//

import SwiftUI

/// 진단탭과 Qna탭에 오른쪽 하단에 있는 작성버튼
struct FloatingButton: View {
    var x: CGFloat
    var y: CGFloat
    var action: () -> Void
    
    //MARK: - Init
    init(x: CGFloat, y: CGFloat, action: @escaping () -> Void) {
        self.x = x
        self.y = y
        self.action = action
    }
    
    //MARK: - Contents
    var body: some View {
        ZStack{
            Button(action: action, label: {
                ZStack{
                    Circle()
                        .frame(width: 67, height: 67)
                        .foregroundStyle(Color.mainBg)
                        .clipShape(Circle())
                    
                    Icon.write.image
                        .fixedSize()
                }
            })
            .zIndex(1)
            .position(x: x, y: y)
        }
    }
}

//MARK: - Preview
struct FloatingButton_Preview: PreviewProvider {
    static var previews: some View {
        FloatingButton(x:130, y: 130, action: {print("hello world!")})
            .previewLayout(.sizeThatFits)
        }
}
