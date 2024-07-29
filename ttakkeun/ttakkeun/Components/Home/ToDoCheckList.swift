//
//  ToDoCheckList.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import SwiftUI

/// 투두 항목의 체크 리스트
struct ToDoCheckList: View {
    
    @Binding var data: TodoList
    @ObservedObject var viewModel: ScheduleViewModel
    let parItem: PartItem
    
    
    // MARK: - Init
    
    init(
        data: Binding<TodoList>,
        viewModel: ScheduleViewModel,
        partItem: PartItem
    ) {
        self._data = data
        self.viewModel = viewModel
        self.parItem = partItem
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
                    Task {
                        viewModel.toggleTodoStatus(for: parItem, todoID: data.id)
                    }
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
        .frame(maxWidth: 203, maxHeight: 16, alignment: .leading)
    }
}
