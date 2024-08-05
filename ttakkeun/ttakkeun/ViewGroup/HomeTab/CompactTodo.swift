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
            HStack {
                Spacer()
                
                Text("more")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_400)
            }
            .padding(.top, -15)
        })
        .padding()
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.gray_200, lineWidth: 1)
        )
        .frame(width: 230)
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
        return VStack(alignment: .leading, spacing: 10) {
            if !todos.isEmpty {
                ForEach(todos.prefix(2), id: \.id) { todo in
                    HStack {
                        ToDoCheckList(data: .constant(todo), viewModel: viewModel, partItem: partItem)
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

// MARK: - Preview

struct CompactTodo_Preview: PreviewProvider {
    
    static var previews: some View {
        CompactTodo(viewModel: ScheduleViewModel(), partItem: .ear)
            .previewLayout(.sizeThatFits)
    }
}
