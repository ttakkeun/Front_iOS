//
//  TodoCheckViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/20/24.
//

import Foundation
import Moya

@MainActor
class TodoCheckViewModel: ObservableObject, @preconcurrency TodoCheckProtocol {
    
    private let provider: MoyaProvider<TodoAPITarget>
    private let diaryProvider: MoyaProvider<ScheduleAPITarget>
    private let partItem: PartItem
    
    @Published var scheduleData: ScheduleInquiryResponseData?
    @Published var todos: [TodoList] = [TodoList(todoID: 1, todoName: "머머하기", todoStatus: false), TodoList(todoID: 1, todoName: "이것도하기", todoStatus: false)]
    
    
    init(
        provider: MoyaProvider<TodoAPITarget> = APIManager.shared.testProvider(for: TodoAPITarget.self),
        diaryProvider: MoyaProvider<ScheduleAPITarget> = APIManager.shared.testProvider(for: ScheduleAPITarget.self),
        partItem: PartItem
    ) {
        self.provider = provider
        self.diaryProvider = diaryProvider
        self.partItem = partItem
    }
    
    // MARK: - Todo API Function
    
    /// 투두 데이터 조회
    /// - Parameter date: 조회 대상 날짜
    public func getTodoData(date: DateRequestData, petID: Int) async {
        diaryProvider.request(.getCalendar(dateData: date, petId: petID)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleGetTodoData(response: response)
            case .failure(let error):
                print("일정 탭 투두 조회 네트워크 에러: \(error)")
            }
        }
    }
    
    /// 투두 조회 API 핸들러
    /// - Parameter response: 투두 조회 ResponseData
    private func handleGetTodoData(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(ResponseData<ScheduleInquiryResponseData>.self, from: response.data)
            DispatchQueue.main.async {
                if decodedData.isSuccess {
                    self.scheduleData = decodedData.result
                    self.filterTodos()
                } else {
                    print("일정 탭 투두 조회 받아오지만 오류 발생 : \(decodedData.message)")
                }
            }
        } catch {
            print("일정 탭 투두 조회 디코더 에러: \(error)")
        }
    }
    
    /// 투두 데이터 해당 필터에 맞춰 필터링
    /// - Parameter parItem: 필터링된 투두 데이터 조회
    private func filterTodos() {
        guard let data = self.scheduleData else {
            todos = []
            return
        }
        
        switch self.partItem {
        case .ear:
            todos = data.earTodo ?? []
        case .eye:
            todos = data.eyeTodo ?? []
        case .hair:
            todos = data.hairTodo ?? []
        case .claw:
            todos = data.clawTodo ?? []
        case .tooth:
            todos = data.toothTodo ?? []
        }
    }
    
    /// 투두 체크 여부
    /// - Parameters:
    ///   - category: 현재 투두의 파트 지정
    ///   - todoID: 투두 아이디
    func toggleTodoStatus(for category: PartItem, todoID: UUID) {
        if let index = todos.firstIndex(where: { $0.id == todoID }) {
            todos[index].todoStatus.toggle()
        }
    }
}
