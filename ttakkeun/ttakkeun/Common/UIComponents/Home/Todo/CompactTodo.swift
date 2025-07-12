//
//  CompactTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

/// 투두 아이템 존재할 경우 표시 카드
struct CompactTodo: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeTodoViewModel
    var partItem: PartItem
    
    // MARK: - Constants
    fileprivate enum CompactTodoConstants {
        static let mainVspacing: CGFloat = 24
        static let todoVspacing: CGFloat = 10
        
        static let mainContentsLeading: CGFloat = 10
        static let mainContentsTrailing: CGFloat = 16
        static let todoListPadding: CGFloat = 10
        static let topPadding: CGFloat = 9
        static let bottomPadding: CGFloat = 11
        
        static let cornerRadius: CGFloat = 20
        static let todoCount: Int = 2
        static let mainContentsHeight: CGFloat = 136
        static let mainContentsWidth: CGFloat = 191
        
        static let rectangleHeight: CGFloat = 160
        
        static let moreText: String = "more"
    }
    
    // MARK: - Init
    init(viewModel: HomeTodoViewModel, partItem: PartItem) {
        self.viewModel = viewModel
        self.partItem = partItem
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero, content: {
            TodoCircle(partItem: partItem, isBefore: false)
            Spacer().frame(height: CompactTodoConstants.mainVspacing)
            todoList
            moreText
        })
        .frame(width: CompactTodoConstants.mainContentsWidth)
        .frame(height: CompactTodoConstants.mainContentsHeight, alignment: .top)
        .padding(.leading, CompactTodoConstants.mainContentsLeading)
        .padding(.trailing, CompactTodoConstants.mainContentsTrailing)
        .padding(.top, CompactTodoConstants.topPadding)
        .padding(.bottom, CompactTodoConstants.bottomPadding)
        .background {
            RoundedRectangle(cornerRadius: CompactTodoConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray200, style: .init())
        }
    }
    
    // MARK: - MiddleContents
    @ViewBuilder
    private var todoList: some View {
        let todos: [TodoList] = getTodos(for: partItem)
        
        VStack(alignment: .leading, spacing: CompactTodoConstants.todoVspacing) {
            if !todos.isEmpty {
                ForEach(todos.prefix(CompactTodoConstants.todoCount), id: \.id) { todo in
                    TodoCheckList(data: .constant(todo),
                                  viewModel: viewModel,
                                  partItem: partItem)
                }
            } else {
                Text("오늘의 \(partItem.toKorean()) 투두를 전부 끝냈어요!")
                    .font(.Body4_medium)
                    .foregroundColor(Color.gray400)
            }
        }
        .padding(.leading, CompactTodoConstants.todoListPadding)
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
    
    // MARK: - BottomContents
    private var moreText: some View {
        HStack {
            Spacer()
            
            if (getTodos(for: partItem).count >= 3) {
                Text(CompactTodoConstants.moreText)
                    .underline(true)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray400)
            }
        }
    }
}

struct CompactTodo_Preview: PreviewProvider {
    static var previews: some View {
        CompactTodo(viewModel: HomeTodoViewModel(container: DIContainer()), partItem: .ear)
    }
}
