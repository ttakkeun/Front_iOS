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
import SwiftUI

protocol ScheduleServiceProtocol {
    func getTodoScheduleData(petId: Int, todoDateRequest: TodoDateRequest) -> AnyPublisher<ResponseData<ScheduleInquiryResponse>, MoyaError>
    
    func patchTodoCheckData(todoId: Int) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
    
    func getCompleteRateData(petId: Int) -> AnyPublisher<ResponseData<TodoCompleteResponse>, MoyaError>
    
    func makeTodoContentsData(todoData: MakeTodoRequest) -> AnyPublisher<ResponseData<TodoCheckResponse>, MoyaError>
}
