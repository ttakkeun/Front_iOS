//
//  ScheduleRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class ScheduleService: ScheduleServiceProtocol {
    
    private let provider: MoyaProvider<ScheduleAPITarget>
    
    init(provider: MoyaProvider<ScheduleAPITarget> = APIManager.shared.createProvider(for: ScheduleAPITarget.self)) {
        self.provider = provider
    }
    
    func getTodoScheduleData(petId: Int, todoDateRequest: TodoDateRequest) -> AnyPublisher<ResponseData<ScheduleInquiryResponse>, MoyaError> {
        return provider.requestPublisher(.getCalendar(petId: petId, todoDateRequest: todoDateRequest))
            .map(ResponseData<ScheduleInquiryResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func patchTodoCheckData(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.patchTodoCheck(todoId: todoId))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getCompleteRateData(petId: Int) -> AnyPublisher<ResponseData<TodoCompleteResponse>, MoyaError> {
        return provider.requestPublisher(.getCompleteRate(petId: petId))
            .map(ResponseData<TodoCompleteResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func makeTodoContentsData(todoData: MakeTodoRequest) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.makeTodoContents(todoData: todoData))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func postRepeatTodoData(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.postRepeatTodo(todoId: todoId))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func postAnotherDayData(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.postAnotherDay(todoId: todoId, newDate: newDate))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func deleteTodoDateData(todoID: Int) -> AnyPublisher<ResponseData<DeleteTodoResponse>, MoyaError> {
        return provider.requestPublisher(.deleteTodo(todoId: todoID))
            .map(ResponseData<DeleteTodoResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func patchTodoNameData(todoId: Int, todoName: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.patchTodoName(todoId: todoId, toodName: todoName))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func patchTodoTransferTomorrowData(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.patchTodoTransferTomorrow(todoId: todoId))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func patchTodoTransferAnotherDayData(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError> {
        return provider.requestPublisher(.patchTodoTransferAnotherDay(todoId: todoId, newDate: newDate))
            .map(ResponseData<TodoCheckResponse>.self)
            .eraseToAnyPublisher()
    }
}
