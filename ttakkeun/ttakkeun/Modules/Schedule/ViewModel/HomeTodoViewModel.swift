//
//  HomeTodoViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation
import Combine
import CombineMoya

class HomeTodoViewModel: ObservableObject, TodoCheckProtocol {
    func sendTodoStatus(todoId: Int) {
        //TODO: - TodoAction
    }
    
    
    @Published var inputDate: TodoDateRequest
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
    
    @Published var todoIsLoading: Bool = true
    
    
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
}
