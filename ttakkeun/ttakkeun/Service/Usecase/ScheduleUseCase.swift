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
import SwiftUI

class ScheduleUseCase: ScheduleUseCaseProtocol {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol = ScheduleRepository()) {
        self.scheduleRepository = scheduleRepository
    }
    
    func executeGetTodoScheduleData(petId: Int, todoDateRequest: TodoDateRequest) -> AnyPublisher<ResponseData<ScheduleInquiryResponse>, MoyaError> {
        return scheduleRepository.getTodoSchedule(petId: petId, todoDateRequest: todoDateRequest)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePatchTodoCheck(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.patchTodoCheck(todoId: todoId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetCompleteRate(petId: Int) -> AnyPublisher<ResponseData<TodoCompleteResponse>, MoyaError> {
        return scheduleRepository.getCompleteRate(petId: petId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeMakeTodoContents(todoData: MakeTodoRequest) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.makeTodoContents(todoData: todoData)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePostRepeatTodoData(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.postRepeatTodo(todoId: todoId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePostAnotherDayData(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.postAnotherDay(todoId: todoId, newDate: newDate)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeDeleteTodoDateData(todoID: Int) -> AnyPublisher<ResponseData<DeleteTodoResponse>, MoyaError> {
        return scheduleRepository.deleteTodoDate(todoID: todoID)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePatchTodoNameData(todoId: Int, todoName: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.patchTodoName(todoId: todoId, todoName: todoName)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executePatchTodoTransferTomorrow(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.patchTodoTransferTomorrow(todoId: todoId)
    }
    
    
    func executePatchTodoTransferAnotherDayData(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleRepository.patchTodoTransferAnotherDay(todoId: todoId, newDate: newDate)
    }
}
