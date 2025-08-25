//
//  RecordUseCaseProtocol.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Combine
import Moya

protocol RecordUseCaseProtocol {
    func executePostGenerateJournal(petId: Int, category: PartItem.RawValue, data: RecordGenerateRequest, questionImage: [Int: [Data]]) -> AnyPublisher<ResponseData<RecordGenerateResponse>, MoyaError>
    func executeGetJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<RecordListResponse>, MoyaError>
    func executeGetSearchJournal(petId: Int, category: PartItem.RawValue, date: String) -> AnyPublisher<ResponseData<RecordListResponse>, MoyaError>
    func executeGetAnswerList(category: PartItem.RawValue) -> AnyPublisher<ResponseData<RecordQuestionResponse>, MoyaError>
    func executeGetDetailJournal(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<RecordResultResponse>, MoyaError>
    func executeDeleteJournal(recordId: Int) -> AnyPublisher<ResponseData<RecordDeleteResponse>,MoyaError>
}
