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
        self.patchTodoStatus(todoId: todoId)
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
    
    func makeTodoContetns(makeTodoData: MakeTodoRequest) {
        container.useCaseProvider.scheduleUseCase.executeMakeTodoContents(todoData: makeTodoData)
            .tryMap { responseData -> ResponseData<TodoCheckResponse> in
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                
                print("MakeTodoContents Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("MakeTodoContents Completed")
                case .failure(let failure):
                    print("MakeTodoContents Failure: \(failure)")
                }
                
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let result = responseData.result {
                    
                    let newTodo = TodoList(todoID: result.todoId,
                                           todoName: self.newTodoText, todoStatus: result.todoStatus)
                    
                    self.todos.append(newTodo)
                    self.newTodoText = ""
                    self.isAddingNewTodoToggle()
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

extension TodoCheckViewModel {
    /// 내일 또 하기
    /// - Parameter todoId: 투두 아이디 입력
    func postRepeatTodo(todoId: Int) {
        container.useCaseProvider.scheduleUseCase.executePostRepeatTodoData(todoId: todoId)
            .tryMap { responseData -> ResponseData<TodoCheckResponse> in
                
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("Repeat Todo Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Repeat Todo Completed")
                case .failure(let failure):
                    print("Repeat Todo Failed: \(failure)")
                }
            },
                  receiveValue: { responseData in
                if let result = responseData.result {
                    print("내일 또 하기 결과: \(result)")
                }
            })
            .store(in: &cancellables)
    }
    
    /// 투두 다른 날짜 또 하기
    func postAnotherDay(todoId: Int, newDate: String) {
        container.useCaseProvider.scheduleUseCase.executePostAnotherDayData(todoId: todoId, newDate: newDate)
            .tryMap { responseData -> ResponseData<TodoCheckResponse> in
                
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("AnotherDay Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("AnotherDay Completed")
                case .failure(let failure):
                    print("AnotherDay Failed: \(failure)")
                }
            },
                  receiveValue: { responseData in
                if let result = responseData.result {
                    print("다른 날 또하기 결과: \(result)")
                }
            })
            .store(in: &cancellables)
    }
    
    /// 투두 날짜 바꾸기
    func patchTodoTransferAnotherDay(todoId: Int, newDate: String) {
        container.useCaseProvider.scheduleUseCase.executePatchTodoTransferAnotherDayData(todoId: todoId, newDate: newDate)
            .tryMap { responseData -> ResponseData<TodoCheckResponse> in
                
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("TransferAnotherDay Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TransferAnotherDay Completed")
                case .failure(let failure):
                    print("TransferAnotherDay Failed: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let result = responseData.result {
                    print("투두 날짜 바꾸기: \(result)")
                    if let index = todos.firstIndex(where: { $0.todoID == result.todoId }) {
                        todos.remove(at: index)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    // 투두 내일하기
    func patchTodoTransferTomorrow(todoId: Int) {
        container.useCaseProvider.scheduleUseCase.executePatchTodoTransferTomorrow(todoId: todoId)
            .tryMap { responseData -> ResponseData<TodoCheckResponse> in
                
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("TransferTomorrowDay Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TransferTomorrowDay Completed")
                case .failure(let failure):
                    print("TransferTomorrowDay Failed: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let result = responseData.result {
                    print("투두 내일하기 \(result)")
                    if let index = todos.firstIndex(where: { $0.todoID == result.todoId }) {
                        todos.remove(at: index)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    // 투두 삭제하기
    func deleteTodo(todoId: Int) {
        container.useCaseProvider.scheduleUseCase.executeDeleteTodoDateData(todoID: todoId)
            .tryMap { responseData -> ResponseData<DeleteTodoResponse> in
                
                if !responseData.isSuccess {
                    throw APIError.serverError(message: responseData.message, code: responseData.code)
                }
                
                guard let _ = responseData.result else {
                    throw APIError.emptyResult
                }
                print("TodoDelete Server: \(responseData)")
                return responseData
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TodoDelete Completed")
                case .failure(let failure):
                    print("TodoDelete Failed: \(failure)")
                }
            },
                  receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                
                if let result = responseData.result {
                    print("투두 삭제하기 \(result)")
                    if let index = todos.firstIndex(where: { $0.todoID == result.todoId }) {
                        todos.remove(at: index)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
