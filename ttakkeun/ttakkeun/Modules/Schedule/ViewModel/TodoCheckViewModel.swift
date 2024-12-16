//
//  TodoCheckViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI
import Combine
import CombineMoya

class TodoCheckViewModel: ObservableObject, TodoCheckProtocol {
    
    @Published var scheduleData: ScheduleInquiryResponse?
    @Published var todos: [TodoList] = []
    @Published var newTodoText: String = ""
    @Published var isAddingNewTodo = false
    
    @Published var isLoading: Bool = false
    
    let partItem: PartItem
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(partItem: PartItem, container: DIContainer) {
        self.partItem = partItem
        self.container = container
    }
    
    private func fileterTodos() {
        guard let data = self.scheduleData else {
            todos = []
            return
        }
        
        switch partItem {
        case .ear:
            todos = data.earTodo
        case .eye:
            todos = data.eyeTodo
        case .hair:
            todos = data.hairTodo
        case .claw:
            todos = data.clawTodo
        case .teeth:
            todos = data.toothTodo
        }
    }
    
    func toggleTodoStatus(for category: PartItem, todoID: UUID) {
        if let index = todos.firstIndex(where: { $0.id == todoID }) {
            todos[index].todoStatus.toggle()
        }
    }
    
    func sendTodoStatus(todoId: Int) {
        //TODO: - TodoCheckAction
    }
    
    func isAddingNewTodoToggle() {
        self.isAddingNewTodo.toggle()
    }
}

extension TodoCheckViewModel {
    func getTodoData(date: Date) {
        isLoading = true
        
        let (year, month, day) = date.toYearMonthDay()
        
        container.useCaseProvider.scheduleUseCase.executeGetTodoScheduleData(petId: UserState.shared.getPetId(), todoDateRequest: TodoDateRequest(year: year, month: month, date: day))
            .tryMap { responseData -> ResponseData<ScheduleInquiryResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("TodoListData Server : \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isLoading = false
                
                switch completion {
                case .finished:
                    print("TodoListData Get Completed")
                case .failure(let failure):
                    print("TodoListData Get Failure: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let responseData = responseData.result {
                    self.scheduleData = responseData
                }
                
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func patchTodoStatus(todoId: Int) {
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

extension Date {
    func toYearMonthDay() -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return (year, month, day)
    }
}
