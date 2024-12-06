//
//  CompactTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct CompactTodo: View {
    
    @ObservedObject var viewModel: HomeTodoViewModel
    var partItem: PartItem
    
    init(viewModel: HomeTodoViewModel, partItem: PartItem) {
        self.viewModel = viewModel
        self.partItem = partItem
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            TodoCircle(partItem: partItem, isBefore: false)
            todoList(partItem: partItem)
            HStack {
                Spacer()
                
                if !getTodos(for: partItem).isEmpty {
                    Text("more")
                        .underline(true)
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray400)
                }
            }
            .padding(.top, -15)
        })
        .padding()
        .background(Color.clear)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.gray200, lineWidth: 1)
        })
        .frame(width: 230, height: 147)
    }
}

extension CompactTodo {
    func todoList(partItem: PartItem) -> some View {
        let todos: [TodoList] = getTodos(for: partItem)
        return VStack(alignment: .leading, spacing: 10) {
            if !todos.isEmpty {
                ForEach(todos.prefix(2), id: \.id) { todo in
                    HStack {
                        TodoCheckList(data: .constant(todo),
                                      viewModel: viewModel,
                                      partItem: partItem)
                        Spacer()
                    }
                }
            } else {
                Text("오늘의 \(partItem.toKorean()) 투두를 전부 끝냈어요!")
                    .font(.Body4_medium)
                    .foregroundColor(Color.gray400)
            }
        }
        .frame(maxWidth: 190)
        .padding(.leading, 10)
    }
    
    private func getTodos(for partItem: PartItem) -> [TodoList] {
            switch partItem {
            case .ear:
                return viewModel.incompleteEarTodos
            case .eye:
                return viewModel.incompleteEyeTodos
            case .hair:
                return viewModel.incompleteHairTodos
            case .claw:
                return viewModel.incompleteClawTodos
            case .teeth:
                return viewModel.incompleteToothTodos
            }
        }
}

struct CompactTodo_Preview: PreviewProvider {
    static var previews: some View {
        CompactTodo(viewModel: HomeTodoViewModel(container: DIContainer()), partItem: .ear)
    }
}
