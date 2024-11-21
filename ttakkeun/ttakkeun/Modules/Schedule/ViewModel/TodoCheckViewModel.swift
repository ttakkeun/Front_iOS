//
//  TodoCheckViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

class TodoCheckViewModel: ObservableObject, TodoCheckProtocol {
    
    @Published var scheduleData: ScheduleInquiryResponse?
    @Published var todos: [TodoList] = []
    @Published var newTodoText: String = ""
    @Published var isAddingNewTodo = false
    
    let partItem: PartItem
    
    init(partItem: PartItem) {
        self.partItem = partItem
    }
    
    private func fileterTodos() {
        guard let data = self.scheduleData else {
            todos = []
            return
        }
        
        switch partItem {
        case .ear:
            todos = data.earTodo ?? []
        case .eye:
            todos = data.eyeTodo ?? []
        case .hair:
            todos = data.hairTodo ?? []
        case .claw:
            todos = data.clawTodo ?? []
        case .teeth:
            todos = data.toothTodo ?? []
        }
    }
    
    func toggleTodoStatus(for category: PartItem, todoID: UUID) {
        if let index = todos.firstIndex(where: { $0.id == todoID }) {
            todos[index].todoStatus.toggle()
        }
    }
    
    func isAddingNewTodoToggle() {
        self.isAddingNewTodo.toggle()
        print(isAddingNewTodo)
    }
}
