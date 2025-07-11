//
//  TodoCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

/// 스케줄 탭 내부의 투두 항목
struct TodoCard: View {
    
    @State var viewModel: TodoCheckViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    init(partItem: PartItem, container: DIContainer) {
        self.viewModel = .init(partItem: partItem, container: container)
    }
    
    var body: some View {
        HStack(content: {
                todoCircle
                
                Spacer().frame(width: 20)
                
                if !viewModel.todos.isEmpty {
                    todoCheckList
                } else {
                    notTodoChecList
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
        .onReceive(calendarViewModel.$selectedDate) { newDate in
            viewModel.getTodoData(date: newDate)
        }
    }
    
    private var todoCheckList: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            ForEach($viewModel.todos, id: \.id) { todo in
                TodoCheckList(data: todo, viewModel: viewModel, partItem: viewModel.partItem, checkAble: true)
            }
            
            if viewModel.isAddingNewTodo {
                newTodoInputField
            }
        })
    }
    
    @ViewBuilder
    private var notTodoChecList: some View {
        if viewModel.isAddingNewTodo {
            newTodoInputField
        } else {
            Text("Todo List를 만들어볼까요?")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
        }
    }
    
    private var todoCircle: some View {
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
            .disabled(viewModel.isAddingNewTodo == true ? true : false)
        })
    }
    
    private var newTodoInputField: some View {
        HStack {
            Icon.unCheckBox.image
                .fixedSize()
            
            VStack(spacing: 0, content: {
                TextField("내용을 입력해주세요!!" ,text: $viewModel.newTodoText)
                    .onSubmit {
                        addNewTodo()
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray900)
                    .tint(Color.black)
                
                Divider()
                    .frame(height: 2)
                    .background(Color.mainPrimary)
            })
            
            Spacer()
            
            HStack(spacing: 8, content: {
                makeButton(action: addNewTodo, image: Icon.plus.image)
                
                makeButton(action: minustTodo, image: Icon.minus.image)
            })
        }
        .frame(width: 240)
    }
}

extension TodoCard {
    
    func minustTodo() {
        viewModel.isAddingNewTodoToggle()
        viewModel.newTodoText = ""
    }
    
    func addNewTodo() {
        guard !viewModel.newTodoText.isEmpty else { return }
        
        viewModel.makeTodoContetns(makeTodoData: MakeTodoRequest(petId: UserState.shared.getPetId(), todoCategory: viewModel.partItem.rawValue, todoName: viewModel.newTodoText))
        viewModel.makeTodoContetns(makeTodoData: MakeTodoRequest(petId: UserState.shared.getPetId(), todoCategory: viewModel.partItem.rawValue, todoName: viewModel.newTodoText))
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
