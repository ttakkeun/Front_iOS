//
//  TodoCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/20/24.
//

import SwiftUI

/// 일지 탭, 항목 체크 투두 카드
struct TodoCard: View {
    
    let partItem: PartItem
    @StateObject var viewModel: TodoCheckViewModel
    @State private var isAddingNewTodo = false
    @State private var newTodoText = ""
    // MARK: - Init
    
    init(partItem: PartItem) {
        self.partItem = partItem
        self._viewModel = StateObject(wrappedValue: TodoCheckViewModel(partItem: partItem))
    }
    
    // MARK: - Contents
    
    var body: some View {
        HStack(spacing: 24, content: {
            self.todoCircle
            
            if !viewModel.todos.isEmpty {
                VStack(alignment: .leading, spacing: 10, content: {
                    ForEach(viewModel.todos, id: \.id) { todo in
                        ToDoCheckList(data: .constant(todo), viewModel: viewModel, partItem: partItem)
                    }
                    if self.isAddingNewTodo {
                        self.newTodoInputField
                    }
                })
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        })
        .frame(width: 310)
        .padding(.vertical, 18)
        .padding(.leading, 8)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.gray_200)
        )
    }
    
    /// 투두 리스트 추가 버튼
    private var todoCircle: some View {
        ZStack(alignment: .topTrailing, content: {
            HomeTodoCircle(partItem: self.partItem, isBefore: false)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.isAddingNewTodo = true
                }
            }, label: {
                Icon.basePlus.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
            })
        })
    }
    
    /// 투두 항목 추가 시, 작성하기 텍스트 필드
    private var newTodoInputField: some View {
        HStack {
            Icon.unCheckBox.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
            
            TextField("내용을 입력해주세요!!" ,text: $newTodoText, onCommit: {
                self.addNewTodo()
            })
            .textFieldStyle(PlainTextFieldStyle())
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_900)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.addNewTodo()
                }
            }, label: {
                Icon.plus.image
                    .fixedSize()
            })
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.isAddingNewTodo = false
                }
            }, label: {
                Icon.minus.image
                    .fixedSize()
            })
        }
        .frame(maxWidth: 203, maxHeight: 16, alignment: .leading)
    }
    
    /// 투두 체크리스트 추가하기
    // TODO: - API 데이터 필요
    private func addNewTodo() {
        guard !newTodoText.isEmpty else { return }
        
        let newTodo = TodoList(todoID: Int.random(in: 1000...9999), todoName: newTodoText, todoStatus: false)
        
        viewModel.todos.append(newTodo)
        newTodoText = ""
        isAddingNewTodo = false
    }
}

// MARK: - Preview

struct ToddCard_Preview: PreviewProvider {
    static var previews: some View {
        TodoCard(partItem: .claw)
            .previewLayout(.sizeThatFits)
    }
}
