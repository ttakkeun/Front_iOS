//
//  HomeNotToDo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct NotToDo: View {
    var body: some View {
        VStack(spacing: 18, content: {
            linearCircleComponents
            
            Text("Todo list를 만들어볼까요?")
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
        })
        .frame(width: 273, height: 147)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.gray200, lineWidth: 1)
        })
    }
    
    private var linearCircleComponents: some View {
        ZStack(alignment: .top, content: {
            makeCircle(partItem: [.claw, .hair])
                .frame(maxWidth: 184)
            
            makeCircle(partItem: [.teeth, .eye])
                .frame(maxWidth: 117)
                .padding(.top, 6)
            
            TodoCircle(partItem: .ear, isBefore: true)
                .padding(.top, 13)
        })
    }
    
    private func makeCircle(partItem: [PartItem]) -> HStack<some View> {
        return HStack {
            TodoCircle(partItem: partItem[0], isBefore: true)
            
            Spacer()
            
            TodoCircle(partItem: partItem[1], isBefore: true)
        }
    }
}

struct NotTodo_Preview: PreviewProvider {
    static var previews: some View {
        NotToDo()
    }
}
