//
//  TestDragView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/17/24.
//

import SwiftUI

struct TestDragView: View {
    @State var isShow: Bool = false
    
    /// CustomAlert 정상작동하는지 Test
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    isShow = true
                }
            }, label: {
                Text("hello world")
            })
            
            
            if isShow {
                CustomAlert(showPopover: $isShow)
            }
        }
        .frame(width: 400, height: 500)
        .background(Color.red)
    }
}

#Preview {
    TestDragView()
}
    




