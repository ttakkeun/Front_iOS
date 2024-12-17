//
//  PetProfileRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

protocol ScheduleRepositoryProtocol {
    func getTodoSchedule(petId: Int, todoDateRequest: TodoDateRequest) -> AnyPublisher<ResponseData<ScheduleInquiryResponse>, MoyaError>
    
    func patchTodoCheck(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func getCompleteRate(petId: Int) -> AnyPublisher<ResponseData<TodoCompleteResponse>, MoyaError>
    
    func makeTodoContents(todoData: MakeTodoRequest) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
}
