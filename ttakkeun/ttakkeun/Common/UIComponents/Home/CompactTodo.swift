//
//  CompactTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct CompactTodo: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    var partItem: PartItem
    
    init(viewModel: ScheduleViewModel, partItem: PartItem) {
        self.viewModel = viewModel
        self.partItem = partItem
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension CompactTodo {
    func todoList(partItem: PartItem) -> some View {
        let todos: [TodoList]
        switch partItem {
        case .ear:
            todos = viewModel.incompleteEarTodos
        case .eye:
            todos = viewModel.incompleteEyeTodos
        case .hair:
            todos = viewModel.incompleteHairTodos
        case .claw:
            todos = viewModel.incompleteClawTodos
        case .teeth:
            todos = viewModel.incompleteToothTodos
        }
        return VStack(alignment: .leading, spacing: 10) {
            if !todos.isEmpty {
                ForEach(todos.prefix(2), id: \.id) { todo in
                    HStack {
                        // TODO: - TodoCheckList 만들기
                        
//                        ToDoCheckList(data: .constant(todo), viewModel: viewModel, partItem: partItem)
                        Spacer()
                    }
                }
            } else {
                Text("오늘의 \(partItem.toKorean()) 투두를 전부 끝냈어요!")
                    .font(.Body4_medium)
                    .foregroundColor(Color.gray400)
                    .padding()
            }
        }
        .frame(width: 190, height: 42)
        .padding(.leading, 10)
    }
}
