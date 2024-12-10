//
//  JournalServiceProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import Foundation
import Combine
import Moya
import SwiftUI

protocol JournalUseCaseProtocol {
    func executeGetJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    func executeGetJournalDetailData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError>
    func executeMakeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError>
    func executeGetAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError>
    func executeDeleteJournal(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError>
    
    func executeMakeDiag(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError>
    
    func executeUpdateNaver(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError>
    
    func executeGetDiagResult(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError>
}
