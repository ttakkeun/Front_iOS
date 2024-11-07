//
//  HomeTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct HomeTodo: View {
    
    @StateObject var viewModel: ScheduleViewModel = ScheduleViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("오늘의 일정관리")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            if viewModel.earTodos.isEmpty && viewModel.hairTodos.isEmpty && viewModel.clawTodos.isEmpty && viewModel.eyeTodos.isEmpty && viewModel.teethTodos.isEmpty {
                
                notTodo
                
            } else {
                
                todoScrollView
                
            }
        })
    }
    
    @ViewBuilder
    private var notTodo: HStack<some View> {
        HStack {
            Spacer()
            
            NotToDo()
            
            Spacer()
        }
    }
    
    private var todoScrollView: some View {
        ScrollView(.horizontal, content: {
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 147)), count: 1), spacing: 12, content: {
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
            .frame(height: 180)
            .padding(.horizontal, 5)
        })
        .scrollIndicators(.visible)
    }
}

#Preview {
    HomeTodo()
}
