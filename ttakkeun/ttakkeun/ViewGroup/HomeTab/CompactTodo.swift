//
//  CompactTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import SwiftUI

struct CompactTodo: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    var partItem: PartItem
    
    init(
        viewModel: ScheduleViewModel,
        partItem: PartItem
    ) {
        self.viewModel = viewModel
        self.partItem = partItem
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            HomeTodoCircle(partItem: partItem, isBefore: false)
            todoList(partItem: partItem)
        })
        .padding()
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.gray_200, lineWidth: 1)
        )
        .frame(maxWidth: 230)
        .onAppear {
            Task {
                await viewModel.getScheduleData(currentDate: viewModel.inputDate)
            }
            
        }
    }
    
    /// 각 부위에 해당하는 체크리스트
    /// - Parameter partItem: 어느 부위인지 값
    /// - Returns: 체크 리스트 항목
    private func todoList(partItem: PartItem) -> some View {
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
        case .tooth:
            todos = viewModel.incompleteToothTodos
        }
        
        return Group {
            if todos.isEmpty {
                Text("오늘의 \(partItem.toKorean()) 투두를 전부 끝냈어요!")
                    .font(.Body4_medium)
                    .foregroundColor(Color.gray400)
                    .padding()
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 110), spacing: 10), count: 2), spacing: 10) {
                    ForEach(todos, id: \.id) { todo in
                        ToDoCheckList(data: .constant(todo), viewModel: viewModel, partItem: partItem)
                    }
                }
                .frame(alignment: .leading)
                .padding(.vertical, 10)
                .padding(.leading, 5)
            }
        }
    }
}

// MARK: - Preview

struct CompactTodo_Preview: PreviewProvider {
    
    static var previews: some View {
        CompactTodo(viewModel: ScheduleViewModel(), partItem: .ear)
            .previewLayout(.sizeThatFits)
    }
}
