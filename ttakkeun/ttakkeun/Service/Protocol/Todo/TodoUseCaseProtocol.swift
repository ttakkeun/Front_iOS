//
//  PetProfileUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Combine
import CombineMoya
import Moya

protocol TodoUseCaseProtocol {
    func executePostGenerateTodo(todoData: TodoGenerateRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executePostRepeatTodo(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executePostAnotherDay(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executeDeleteTodoDate(todoID: Int) -> AnyPublisher<ResponseData<TodoDeleteResponse>, MoyaError>
    func executePatchTodoName(todoId: Int, todoName: TodoPatchRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executePatchTodoTransferTomorrow(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executePatchTodoCheck(todoId: Int) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executePatchTodoTransferAnotherDay(todoId: Int, newDate: TodoAnotherDayRequest) -> AnyPublisher<ResponseData<TodoInfoResponse>, MoyaError>
    func executeGetCompleteRate(petId: Int) -> AnyPublisher<ResponseData<TodoCompletionResponse>, MoyaError>
    func executeGetCalendar(petId: Int, todoDateRequest: TodoCalendarRequest) -> AnyPublisher<ResponseData<TodoCalendarResponse>, MoyaError>}
