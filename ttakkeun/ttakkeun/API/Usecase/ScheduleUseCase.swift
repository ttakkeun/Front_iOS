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
}
