//
//  RecordServiceProtocol.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Combine
import Moya

protocol RecordServiceProtocol {
    func postGenerateJournalData(petId: Int, category: PartItem.RawValue, data: RecordGenerateRequest, questionImage: [Int: [Data]]) -> AnyPublisher<ResponseData<RecordGenerateResponse>, MoyaError>
    func getJournalListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<RecordListResponse>, MoyaError>
    func getSearchJournalData(petId: Int, category: PartItem.RawValue, date: String) -> AnyPublisher<ResponseData<RecordListResponse>, MoyaError>
    func getAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<RecordQuestionResponse>, MoyaError>
    func getDetailJournalData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<RecordResultResponse>, MoyaError>
    func deleteJournalData(recordId: Int) -> AnyPublisher<ResponseData<RecordDeleteResponse>,MoyaError>
}
