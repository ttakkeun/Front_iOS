//
//  ToDoCheckList.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import SwiftUI

/// 투두 항목의 체크 리스트
struct ToDoCheckList: View {
    
    @ObservedObject var viewModel: HomeSceduleViewModel
    @State var data: TodoList
    let isCompact: Bool
    
    
    // MARK: - Init
    
    init(
        viewModel: HomeSceduleViewModel,
        data: TodoList,
        isCompact: Bool = true
    ) {
        self.viewModel = viewModel
        self.isCompact = isCompact
        self.data = data
    }
    
    var body: some View {
        checkComponents
    }
    
    // MARK: - Contents
    
    private var checkComponents: some View {
        HStack(alignment: .center, spacing: 6, content: {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    data.todoStatus.toggle()
                }
            }, label: {
                if !data.todoStatus {
                    Icon.unCheckBox.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .opacity(data.todoStatus ? 0 : 1)
                    
                } else {
                    ZStack {
                        Icon.checkBox.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Icon.checkV.image
                            .fixedSize()
                    }
                }
            })
            
            Text(data.todoName)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray_900)
        })
        .frame(maxWidth: 203, alignment: .leading)
    }
}

// MARK: - Contents

struct TodoCheckList_Preview: PreviewProvider {
    static var previews: some View {
        ToDoCheckList(viewModel: HomeSceduleViewModel(), data: TodoList(todoID: 1, todoName: "이빨닦기 및 청소", todoStatus: false))
    }
}
