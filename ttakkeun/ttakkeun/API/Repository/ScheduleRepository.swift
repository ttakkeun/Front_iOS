//
//  ScheduleRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

class ScheduleRepository: ScheduleRepositoryProtocol {
    
    private let scheduleService: ScheduleServiceProtocol
    
    init(scheduleService: ScheduleServiceProtocol = ScheduleService()) {
        self.scheduleService = scheduleService
    }
    
    func getTodoSchedule(petId: Int, todoDateRequest: TodoDateRequest) -> AnyPublisher<ResponseData<ScheduleInquiryResponse>, MoyaError> {
        return scheduleService.getTodoScheduleData(petId: petId, todoDateRequest: todoDateRequest)
    }
    
    func patchTodoCheck(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.patchTodoCheckData(todoId: todoId)
    }
    
    func getCompleteRate(petId: Int) -> AnyPublisher<ResponseData<TodoCompleteResponse>, MoyaError> {
        return scheduleService.getCompleteRateData(petId: petId)
    }
    
    func makeTodoContents(todoData: MakeTodoRequest) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.makeTodoContentsData(todoData: todoData)
    }
    
    func postRepeatTodo(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.postRepeatTodoData(todoId: todoId)
    }
    
    func postAnotherDay(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.postAnotherDayData(todoId: todoId, newDate: newDate)
    }
    
    func deleteTodoDate(todoID: Int) -> AnyPublisher<ResponseData<DeleteTodoResponse>, MoyaError> {
        return scheduleService.deleteTodoDateData(todoID: todoID)
    }
    
    func patchTodoName(todoId: Int, todoName: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.patchTodoNameData(todoId: todoId, todoName: todoName)
    }
    
    func patchTodoTransferTomorrow(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.patchTodoTransferTomorrowData(todoId: todoId)
    }
    
    func patchTodoTransferAnotherDay(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return scheduleService.patchTodoTransferAnotherDayData(todoId: todoId, newDate: newDate)
    }
}
