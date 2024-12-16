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
}
