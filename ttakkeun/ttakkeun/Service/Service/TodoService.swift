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

class TodoService: TodoServiceProtocol, BaseAPIService {
    typealias Target = TodoRouter
    
    let provider: MoyaProvider<TodoRouter>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<TodoRouter> = APIManager.shared.createProvider(for: TodoRouter.self),
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase
            return d
        }(),
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func postGenerateTodo(todoData: TodoGenerateRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.postGenerateTodo(todoData: todoData))
    }
    
    func postRepeatTodoData(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.postRepeatTodo(todoId: todoId))
    }
    
    func postAnotherDayData(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.postAnotherDay(todoId: todoId, newDate: newDate))
    }
    
    func deleteTodoDateData(todoID: Int) -> AnyPublisher<ResponseData<TodoDeleteResponse>, Moya.MoyaError> {
        request(.deleteTodo(todoId: todoID))
    }
    
    func patchTodoNameData(todoId: Int, todoName: TodoPatchRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.patchTodoName(todoId: todoId, toodName: todoName))
    }
    
    func patchTodoTransferTomorrowData(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.patchTodoTransferTomorrow(todoId: todoId))
    }
    
    func patchTodoCheckData(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.patchTodoCheck(todoId: todoId))
    }
    
    func patchTodoTransferAnotherDayData(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, Moya.MoyaError> {
        request(.patchTodoTransferAnotherDay(todoId: todoId, newDate: newDate))
    }
    
    func getCompleteRateData(petId: Int) -> AnyPublisher<ResponseData<TodoCompletionResponse>, Moya.MoyaError> {
        request(.getCompleteRate(petId: petId))
    }
    
    func getCalendarData(petId: Int, todoDateRequest: TodoCalendarRequest) -> AnyPublisher<ResponseData<TodoCalendarResponse>, Moya.MoyaError> {
        request(.getCalendar(petId: petId, todoDateRequest: todoDateRequest))
    }
    
}
