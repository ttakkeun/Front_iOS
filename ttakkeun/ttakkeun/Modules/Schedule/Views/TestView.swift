//
//  TestView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/23/24.
//

import SwiftUI

struct TestView: View {
    
    @State var isShowing: Bool = false
    
    var body: some View {
        Button(action: {
            isShowing.toggle()
        }, label: {
            Text("hello")
        })
        .sheet(isPresented: $isShowing, content: {
            TodoOptionSheetView(viewModel: TodoCheckViewModel(partItem: .claw, container: DIContainer()), selectedTodo: .constant(.init(todoID: 1, todoName: "테스트입니다아아", todoStatus: true)), isShowSheet: .constant(true))
                .presentationCornerRadius(30)
                .presentationDetents([.fraction(0.4)])
        })
    }
}

#Preview {
    TestView()
}
