//
//  HomeTodoViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation

class HomeTodoViewModel: ObservableObject, TodoCheckProtocol {
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    
    @Published var earTodos: [TodoList] = []
    @Published var hairTodos: [TodoList] = []
    @Published var clawTodos: [TodoList] = []
    @Published var eyeTodos: [TodoList] = []
    @Published var teethTodos: [TodoList] = []
    
    var incompleteEarTodos: [TodoList] { earTodos.filter { !$0.todoStatus } }
    var incompleteEyeTodos: [TodoList] { eyeTodos.filter { !$0.todoStatus } }
    var incompleteHairTodos: [TodoList] { hairTodos.filter { !$0.todoStatus } }
    var incompleteClawTodos: [TodoList] { clawTodos.filter { !$0.todoStatus } }
    var incompleteToothTodos: [TodoList] { teethTodos.filter { !$0.todoStatus } }
    
    public func toggleTodoStatus(for category: PartItem, todoID: UUID) {
        switch category {
        case .ear:
            if let index = earTodos.firstIndex(where: { $0.id == todoID }) {
                earTodos[index].todoStatus.toggle()
            }
        case .eye:
            if let index = eyeTodos.firstIndex(where: { $0.id == todoID }) {
                eyeTodos[index].todoStatus.toggle()
            }
        case .hair:
            if let index = hairTodos.firstIndex(where: { $0.id == todoID }) {
                hairTodos[index].todoStatus.toggle()
            }
        case .claw:
            if let index = clawTodos.firstIndex(where: { $0.id == todoID }) {
                clawTodos[index].todoStatus.toggle()
            }
        case .teeth:
            if let index = teethTodos.firstIndex(where: { $0.id == todoID }) {
                teethTodos[index].todoStatus.toggle()
            }
        }
    }
}
