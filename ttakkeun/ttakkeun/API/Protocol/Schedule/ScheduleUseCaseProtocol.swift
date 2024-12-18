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
import SwiftUI

protocol ScheduleUseCaseProtocol {
    func executeGetTodoScheduleData(petId: Int, todoDateRequest: TodoDateRequest) -> AnyPublisher<ResponseData<ScheduleInquiryResponse>, MoyaError>
    
    func executePatchTodoCheck(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func executeGetCompleteRate(petId: Int) -> AnyPublisher<ResponseData<TodoCompleteResponse>, MoyaError>
    
    func executeMakeTodoContents(todoData: MakeTodoRequest) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func executePostRepeatTodoData(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func executePostAnotherDayData(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func executeDeleteTodoDateData(todoID: Int) -> AnyPublisher<ResponseData<DeleteTodoResponse>, MoyaError>
    
    func executePatchTodoNameData(todoId: Int, todoName: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func executePatchTodoTransferTomorrow(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func executePatchTodoTransferAnotherDayData(todoId: Int, newDate: String) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
}
