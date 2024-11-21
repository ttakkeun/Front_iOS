//
//  TodoCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

/// 스케줄 탭 내부의 투두 항목
struct TodoCard: View {
    
    @StateObject var viewModel: TodoCheckViewModel
    
    init(partItem: PartItem) {
        self._viewModel = StateObject(wrappedValue: .init(partItem: partItem))
    }
    
    var body: some View {
        HStack(content: {
                todoCicle
                
                Spacer().frame(width: 20)
                
                if !viewModel.todos.isEmpty {
                    todoCheckList
                } else {
                    notTOdoChecList
                }
                
                Spacer()
        })
        .frame(width: 318)
        .padding(.leading, 14)
        .padding(.trailing, 18)
        .padding(.top, 14)
        .padding(.bottom, 18)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .stroke(Color.gray200, lineWidth: 1)
        }
    }
    
    private var todoCheckList: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            ForEach(viewModel.todos, id: \.self) { todo in
                TodoCheckList(data: .constant(todo), viewModel: viewModel, partItem: viewModel.partItem, checkAble: true)
            }
            
            if viewModel.isAddingNewTodo {
                newTodoInputField
            }
        })
    }
    
    @ViewBuilder
    private var notTOdoChecList: some View {
        if viewModel.isAddingNewTodo {
            newTodoInputField
        } else {
            Text("Todo List를 만들어볼까요?")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
        }
    }
    
    private var todoCicle: some View {
        ZStack(alignment: .topTrailing, content: {
            TodoCircle(partItem: viewModel.partItem, isBefore: true)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.isAddingNewTodoToggle()
                }
            }, label: {
                Icon.todoPlus.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            })
        })
    }
    
    private var newTodoInputField: some View {
        HStack {
            Icon.unCheckBox.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 17, height: 17)
            
            TextField("내용을 입력해주세요!!" ,text: $viewModel.newTodoText)
                .onSubmit {
                    addNewTodo()
                }
                .textFieldStyle(PlainTextFieldStyle())
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .tint(Color.black)
            
            Spacer()
            
            HStack(spacing: 8, content: {
                makeButton(action: addNewTodo, image: Icon.plus.image)
                
                makeButton(action: viewModel.isAddingNewTodoToggle, image: Icon.minus.image)
            })
        }
        .frame(width: 240)
    }
}

extension TodoCard {
    func addNewTodo() {
        guard !viewModel.newTodoText.isEmpty else { return }
        
        let newTodo = TodoList(todoID: Int.random(in: 1...214748364),
                               todoName: viewModel.newTodoText, todoStatus: false)
        
        viewModel.todos.append(newTodo)
        viewModel.newTodoText = ""
        viewModel.isAddingNewTodoToggle()
    }
    
    func makeButton(action: @escaping () -> Void, image: Image) -> some View {
        Button(action: {
            withAnimation(.smooth(duration: 0.3)) {
                action()
            }
        }, label: {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
        })
    }
}

struct TodoCard_Preview: PreviewProvider {
    static var previews: some View {
        TodoCard(partItem: .ear)
    }
}
