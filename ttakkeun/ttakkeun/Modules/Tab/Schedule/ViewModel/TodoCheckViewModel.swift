//
//  TodoCheckViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI
import Combine
import CombineMoya

@Observable
class TodoCheckViewModel: TodoCheckProtocol {
    // MARK: - StateProperty
    var isAddingNewTodo = false
    var isLoading: Bool = false
    
    // MARK: - Property
    var scheduleData: TodoCalendarResponse?
    var todos: [TodoList] = []
    let partItem: PartItem
    var newTodoText: String = ""
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(partItem: PartItem, container: DIContainer) {
        self.partItem = partItem
        self.container = container
    }
    
    // MARK: - Common
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
    
    // MARK: - Todo API
    /// 투두 가져오기
    /// - Parameter date: 투두 데이터 날짜 입력
    func getTodoData(date: Date) {
        isLoading = true
        
        let (year, month, day) = date.toYearMonthDay()
        
        container.useCaseProvider.todoUseCase.executeGetCalendar(petId: petId, todoDateRequest: .init(year: year, month: month, date: day))
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.isLoading = false }
                
                switch completion {
                case .finished:
                    print("TodoListGet Data Completed")
                case .failure(let failure):
                    print("TodoListGet Data Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                self.scheduleData = responseData
                self.fileterTodos()
            })
            .store(in: &cancellables)
    }
    
    /// 투두 상태 토글 입력
    /// - Parameter todoId: 투두 아이디
    func patchTodoStatus(todoId: Int) {
        container.useCaseProvider.todoUseCase.executePatchTodoCheck(todoId: todoId)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("patchTodoStatus Get Completed")
                case .failure(let failure):
                    print("patchTodoStatus Get Failure: \(failure)")
                }
                
            }, receiveValue: { responseData in
#if DEBUG
                print("투두 체크 상태: \(responseData)")
#endif
            })
            .store(in: &cancellables)
    }
    
    /// 투두 생성 함수
    /// - Parameter makeTodoData: 투두 데이터
    func makeTodoContetns(makeTodoData: TodoGenerateRequest) {
        container.useCaseProvider.todoUseCase.executePostGenerateTodo(todoData: makeTodoData)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("MakeTodoContents Completed")
                case .failure(let failure):
                    print("MakeTodoContents Failure: \(failure)")
                }
                
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                let newTodo = TodoList(todoID: responseData.todoId,
                                       todoName: self.newTodoText, todoStatus: responseData.todoStatus)
                
                self.todos.append(newTodo)
                self.newTodoText.removeAll()
                self.isAddingNewTodoToggle()
            })
            .store(in: &cancellables)
    }
    
    /// 투두 내일 또 하기
    /// - Parameter todoId: 투두 아이디
    func postRepeatTodo(todoId: Int) {
        container.useCaseProvider.todoUseCase.executePostRepeatTodo(todoId: todoId)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Repeat Todo Completed")
                case .failure(let failure):
                    print("Repeat Todo Failed: \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("내일 또 하기 결과: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
    
    /// 투두 다른 날짜 또 하기
    func postAnotherDay(todoId: Int, newDate: String) {
        container.useCaseProvider.todoUseCase.executePostAnotherDay(todoId: todoId, newDate: .init(newDate: newDate))
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("AnotherDay Completed")
                case .failure(let failure):
                    print("AnotherDay Failed: \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("다른 날 또하기 결과: \(responseData)")
                #endif
            })
            .store(in: &cancellables)
    }
    
    /// 투두 날짜 바꾸기
    func patchTodoTransferAnotherDay(todoId: Int, newDate: String) {
        container.useCaseProvider.todoUseCase.executePatchTodoTransferAnotherDay(todoId: todoId, newDate: .init(newDate: newDate))
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TransferAnotherDay Completed")
                case .failure(let failure):
                    print("TransferAnotherDay Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                #if DEBUG
                print("투두 날짜 바꾸기: \(responseData)")
                #endif
                if let index = todos.firstIndex(where: { $0.todoID == responseData.todoId }) {
                    todos.remove(at: index)
                }
            })
            .store(in: &cancellables)
    }
    
    // 투두 내일하기
    func patchTodoTransferTomorrow(todoId: Int) {
        container.useCaseProvider.todoUseCase.executePatchTodoTransferTomorrow(todoId: todoId)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TransferTomorrowDay Completed")
                case .failure(let failure):
                    print("TransferTomorrowDay Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                #if DEBUG
                print("투두 내일하기 \(responseData)")
                #endif
                if let index = todos.firstIndex(where: { $0.todoID == responseData.todoId }) {
                    todos.remove(at: index)
                }
            })
            .store(in: &cancellables)
    }
    
    // 투두 삭제하기
    func deleteTodo(todoId: Int) {
        container.useCaseProvider.todoUseCase.executeDeleteTodoDate(todoID: todoId)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TodoDelete Completed")
                case .failure(let failure):
                    print("TodoDelete Failed: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                print("투두 삭제하기 \(responseData)")
                if let index = todos.firstIndex(where: { $0.todoID == responseData.todoId }) {
                    todos.remove(at: index)
                }
            })
            .store(in: &cancellables)
    }
    
    /// 투두 이름 수정
    /// - Parameter selectedTodo: 선택한 투두 데이터
    func patchName(selectedTodo: TodoList) {
        container.useCaseProvider.todoUseCase.executePatchTodoName(todoId: selectedTodo.todoID, todoName: .init(todoName: selectedTodo.todoName))
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("TodoNamePatch Completed")
                case .failure(let failure):
                    print("TodoNamePatch Failed: \(failure)")
                }
            }, receiveValue: { responseData in
                print("투두 이름 변경: \(responseData)")
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
