//
//  HomeTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeTodo: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeTodoViewModel
    
    // MARK: - Constants
    fileprivate enum HomeTodoConstants {
        static let titleText: String = "오늘의 일정 관리"
        static let mainVspacing: CGFloat = 16
        static let gridSpacing: CGFloat = 12
        static let rowCount: Int = 1
    }
    
    // MARK: - Init
    var body: some View {
        VStack(alignment: .leading, spacing: HomeTodoConstants.mainVspacing, content: {
            title
            
            if !viewModel.todoIsLoading {
                if viewModel.allTodosEmpty {
                    notTodo
                } else {
                    todoScrollView
                }
            }
        })
    }
    
    // MARK: - TopContents
    /// 일정 관리 타이틀
    private var title: some View {
        Text(HomeTodoConstants.titleText)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 투두 하나라도 없는 경우
    private var notTodo: some View {
        NotToDo()
    }
    
    /// 투두 하나라도 있는 경우
    @ViewBuilder
    private var todoScrollView: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: HomeTodoConstants.gridSpacing, content: {
                if !viewModel.earTodos.isEmpty {
                    CompactTodo(viewModel: viewModel, partItem: .ear)
                }
                
                if !viewModel.hairTodos.isEmpty {
                    CompactTodo(viewModel: viewModel, partItem: .hair)
                }
                
                if !viewModel.clawTodos.isEmpty {
                    CompactTodo(viewModel: viewModel, partItem: .claw)
                }
                
                
                if !viewModel.eyeTodos.isEmpty {
                    CompactTodo(viewModel: viewModel, partItem: .eye)
                }
                
                
                if !viewModel.teethTodos.isEmpty {
                    CompactTodo(viewModel: viewModel, partItem: .teeth)
                }
            })
        })
        .contentMargins(.bottom, UIConstants.horizonScrollBottomPadding, for: .scrollContent)
    }
}

#Preview {
    HomeTodo(viewModel: .init(container: DIContainer()))
}
