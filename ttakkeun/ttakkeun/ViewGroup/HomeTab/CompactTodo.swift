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
        
    }
    
    /// 각 부위에 해당하는 체크리스트
    /// - Parameter partItem: 어느 부위인지 값
    /// - Returns: 체크 리스트 항목
    private func todoList(partItem: PartItem) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 110), spacing: 10), count: 2), spacing: 10, content: {
                ForEach(viewModel.filterUncheckedTodos(), id: \.id) { todo in
                    ToDoCheckList(data: Binding(get: {
                        viewModel.data.first { $0.id == todo.id }!
                    }, set: { newValue in
                        if let index = viewModel.data.firstIndex(where: { $0.id == todo.id }) {
                            viewModel.data[index] = newValue
                        }
                    }))
                }
            })
        .frame(alignment: .leading)
        .padding(.vertical, 10)
        .padding(.leading, 5)
    }
}

// MARK: - Preview

struct CompactTodo_Preview: PreviewProvider {
    
    static var previews: some View {
        CompactTodo(viewModel: ScheduleViewModel(), partItem: .ear)
            .previewLayout(.sizeThatFits)
    }
}
