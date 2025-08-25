//
//  ScheduleRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

class TodoUseCase: TodoUseCaseProtocol {
    private let service: TodoServiceProtocol
    
    init(service: TodoServiceProtocol = TodoService()) {
        self.service = service
    }
    
    /// 투두 생성
    func executePostGenerateTodo(todoData: TodoGenerateRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.postGenerateTodo(todoData: todoData)
    }
    /// 투두 내일 또 하기
    func executePostRepeatTodo(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.postRepeatTodoData(todoId: todoId)
    }
    /// 투두 다른 날 또 하기
    func executePostAnotherDay(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.postAnotherDayData(todoId: todoId, newDate: newDate)
    }
    /// 투두 삭제
    func executeDeleteTodoDate(todoID: Int) -> AnyPublisher<ResponseData<TodoDeleteResponse>, Moya.MoyaError> {
        return service.deleteTodoDateData(todoID: todoID)
    }
    /// 투두 수정
    func executePatchTodoName(todoId: Int, todoName: TodoPatchRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.patchTodoNameData(todoId: todoId, todoName: todoName)
    }
    /// 투두 내일하기
    func executePatchTodoTransferTomorrow(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.patchTodoTransferTomorrowData(todoId: todoId)
    }
    /// 투두 체크/취소 업데이트
    func executePatchTodoCheck(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.patchTodoCheckData(todoId: todoId)
    }
    /// 투두 날짜 바꾸기
    func executePatchTodoTransferAnotherDay(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        return service.patchTodoTransferAnotherDayData(todoId: todoId, newDate: newDate)
    }
    /// 일정 완수율 조회
    func executeGetCompleteRate(petId: Int) -> AnyPublisher<ResponseData<TodoCompletionResponse>, Moya.MoyaError> {
        return service.getCompleteRateData(petId: petId)
    }
    /// 캘린더 조회
    func executeGetCalendar(petId: Int, todoDateRequest: TodoCalendarRequest) -> AnyPublisher<ResponseData<TodoCalendarResponse>, Moya.MoyaError> {
        return service.getCalendarData(petId: petId, todoDateRequest: todoDateRequest)
    }
}
