//
//  HomeTodoViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation
import Combine
import CombineMoya

@Observable
class HomeTodoViewModel: TodoCheckProtocol {
    var inputDate: TodoDateRequest
    
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        self.inputDate = TodoDateRequest(year: year, month: month, date: day)
    }
    
    var todoIsLoading: Bool = false
    var allTodosEmpty: Bool {
        earTodos.isEmpty &&
        hairTodos.isEmpty &&
        clawTodos.isEmpty &&
        eyeTodos.isEmpty &&
        teethTodos.isEmpty
    }
    
    var earTodos: [TodoList] = [
        .init(todoID: 1, todoName: "으아아아ㅏ아아아아아아", todoStatus: false),
        .init(todoID: 2, todoName: "으아아으이이이이이이이잉아ㅏ아아아아아아", todoStatus: false),
    ]
    var hairTodos: [TodoList] = []
    var clawTodos: [TodoList] = []
    var eyeTodos: [TodoList] = []
    var teethTodos: [TodoList] = []
    
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
    
    private func processFetchData(_ data: ScheduleInquiryResponse) {
        self.earTodos = data.earTodo
        self.hairTodos = data.hairTodo
        self.clawTodos = data.clawTodo
        self.eyeTodos = data.eyeTodo
        self.teethTodos = data.toothTodo
    }
}

// MARK: - HomeTodoAPI

extension HomeTodoViewModel {
    public func getTodoSchedule() {
        todoIsLoading = true
        
        container.useCaseProvider.scheduleUseCase.executeGetTodoScheduleData(petId: UserState.shared.getPetId(), todoDateRequest: inputDate)
            .tryMap { responseData -> ResponseData<ScheduleInquiryResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                print("Home Todo Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.todoIsLoading = false
                
                switch completion {
                case .finished:
                    print("Todo Loaded Completed")
                case .failure(let failure):
                    print("Todo Loaded Failure: \(failure)")
                }
                
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                if let responseData = responseData.result {
                    processFetchData(responseData)
                }
            })
            .store(in: &cancellables)
    }
    
    func sendTodoStatus(todoId: Int) {
        container.useCaseProvider.scheduleUseCase.executePatchTodoCheck(todoId: todoId)
            .tryMap { responseData -> ResponseData<TodoCheckResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("patchTodoStatus Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("patchTodoStatus Get Completed")
                case .failure(let failure):
                    print("patchTodoStatus Get Failure: \(failure)")
                }
                
            }, receiveValue: { responseData in
                if let responseData = responseData.result {
                    print("투두 체크 상태: \(responseData)")
                }
            })
            .store(in: &cancellables)
    }
}
