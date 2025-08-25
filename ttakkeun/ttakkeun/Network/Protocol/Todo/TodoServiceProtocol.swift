//
//  PetProfileService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Foundation
import Combine
import Moya

protocol TodoServiceProtocol {
    func postGenerateTodo(todoData: TodoGenerateRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func postRepeatTodoData(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func postAnotherDayData(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func deleteTodoDateData(todoID: Int) -> AnyPublisher<ResponseData<TodoDeleteResponse>, MoyaError>
    func patchTodoNameData(todoId: Int, todoName: TodoPatchRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func patchTodoTransferTomorrowData(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func patchTodoCheckData(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func patchTodoTransferAnotherDayData(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func getCompleteRateData(petId: Int) -> AnyPublisher<ResponseData<TodoCompletionResponse>, MoyaError>
    func getCalendarData(petId: Int, todoDateRequest: TodoCalendarRequest) -> AnyPublisher<ResponseData<TodoCalendarResponse>, MoyaError>
}
