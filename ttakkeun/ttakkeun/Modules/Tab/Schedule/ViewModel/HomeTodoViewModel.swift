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
    // MARK: - StateProperty
    var todoIsLoading: Bool = false
    var allTodosEmpty: Bool {
        earTodos.isEmpty &&
        hairTodos.isEmpty &&
        clawTodos.isEmpty &&
        eyeTodos.isEmpty &&
        teethTodos.isEmpty
    }
    
    // MARK: - Property
    var inputDate: TodoCalendarRequest
    let petId = UserDefaults.standard.integer(forKey: AppStorageKey.petId)
    
    // MARK: - PartProperty
    var earTodos: [TodoList] = []
    var hairTodos: [TodoList] = []
    var clawTodos: [TodoList] = []
    var eyeTodos: [TodoList] = []
    var teethTodos: [TodoList] = []
    
    // MARK: - IncompletedPart
    var incompleteEarTodos: [TodoList] { earTodos.filter { !$0.todoStatus } }
    var incompleteEyeTodos: [TodoList] { eyeTodos.filter { !$0.todoStatus } }
    var incompleteHairTodos: [TodoList] { hairTodos.filter { !$0.todoStatus } }
    var incompleteClawTodos: [TodoList] { clawTodos.filter { !$0.todoStatus } }
    var incompleteToothTodos: [TodoList] { teethTodos.filter { !$0.todoStatus } }
    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
        
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        self.inputDate = .init(year: year, month: month, date: day)
    }
    // MARK: - Common
    
    /// 투두 체크 박스 선택 및 해제
    /// - Parameters:
    ///   - category: 카테고리 값
    ///   - todoID: 투두 아이디
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
    
    /// 서버로부터 받은 데이터 분배
    /// - Parameter data: 투두 값 분배
    private func processFetchData(_ data: TodoCalendarResponse) {
        self.earTodos = data.earTodo
        self.hairTodos = data.hairTodo
        self.clawTodos = data.clawTodo
        self.eyeTodos = data.eyeTodo
        self.teethTodos = data.toothTodo
    }
    
    // MARK: - Todo API
    /// 투두 스케줄 가져오기
    public func getTodoSchedule() {
        todoIsLoading = true
        
        container.useCaseProvider.todoUseCase.executeGetCalendar(petId: petId, todoDateRequest: inputDate)
            .validateResult()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { self.todoIsLoading = false }
                switch completion {
                case .finished:
                    print("Todo Loaded Completed")
                case .failure(let failure):
                    print("Todo Loaded Failure: \(failure)")
                }
            }, receiveValue: { [weak self] responseData in
                guard let self = self else { return }
                processFetchData(responseData)
            })
            .store(in: &cancellables)
    }
    
    /// 투두 상태 체크
    /// - Parameter todoId: 체크하려는 투두 아이디
    func sendTodoStatus(todoId: Int) {
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
}
