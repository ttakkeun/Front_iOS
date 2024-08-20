//
//  HomeSceduleManagement.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import Foundation
import Moya

@MainActor
class ScheduleViewModel: ObservableObject, @preconcurrency TodoCheckProtocol {
    @Published var inputDate: DateRequestData
    @Published var scheduleData: ScheduleInquiry?
    
    private let provider: MoyaProvider<ScheduleAPITarget>
    
    
    // MARK: - API Data Array
    
    @Published var earTodos: [TodoList] = []
    @Published var hairTodos: [TodoList] = []
    @Published var clawTodos: [TodoList] = []
    @Published var eyeTodos: [TodoList] = []
    @Published var toothTodos: [TodoList] = []
    
    var incompleteEarTodos: [TodoList] { earTodos.filter { !$0.todoStatus } }
    var incompleteEyeTodos: [TodoList] { eyeTodos.filter { !$0.todoStatus } }
    var incompleteHairTodos: [TodoList] { hairTodos.filter { !$0.todoStatus } }
    var incompleteClawTodos: [TodoList] { clawTodos.filter { !$0.todoStatus } }
    var incompleteToothTodos: [TodoList] { toothTodos.filter { !$0.todoStatus } }
    
    // MARK: - Init
    
    init(provider: MoyaProvider<ScheduleAPITarget> = APIManager.shared.testProvider(for: ScheduleAPITarget.self)) {
        self.provider = provider
        
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        self.inputDate = DateRequestData(year: year, month: month, date: day)
    }
  
    
    
    // MARK: - API Function
    
    /// 스케줄 일정 조회 API 호출 함수
    /// - Parameter currentDate: 현재 날짜 기준 전달
    public func getScheduleData(currentDate: DateRequestData) async {
        provider.request(.getCalendar(dateData: currentDate)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleScheduleResponse(response: response)
            case .failure(let error):
                print("Todo 캘린더 조회 네트워크 오류: \(error)")
            }
        }
    }
    
    /// ToDo 캘린더 조회 Response 핸들러
    /// - Parameter response: API 호출 후, Response 데이터
    private func handleScheduleResponse(response: Response) {
        do {
            let decodedData = try JSONDecoder().decode(ScheduleInquiry.self, from: response.data)
            DispatchQueue.main.async {
                self.processFetchData(decodedData.result)
                print("캘린더 정보 조회 완료")
            }
        } catch {
            print("ToDo 캘린더 조회 디코더 에러: \(error)")
        }
    }
    
    // MARK: - TodoData Function
    
    /// 부위별 데이터 분리 작업 함수
    /// - Parameter data: response로 받아온 전체 데이터
    private func processFetchData(_ data: ScheduleInquiryResponseData) {
        DispatchQueue.main.async { [weak self] in
            self?.earTodos = data.earTodo ?? []
            self?.hairTodos = data.hairTodo ?? []
            self?.clawTodos = data.clawTodo ?? []
            self?.eyeTodos = data.eyeTodo ?? []
            self?.toothTodos = data.toothTodo ?? []
        }
    }
    
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
        case .tooth:
            if let index = toothTodos.firstIndex(where: { $0.id == todoID }) {
                toothTodos[index].todoStatus.toggle()
            }
        }
    }
}
