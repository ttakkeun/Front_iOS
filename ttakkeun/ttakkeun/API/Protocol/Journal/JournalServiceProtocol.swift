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

protocol JournalServiceProtocol {
    func getJournalListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    
    func getJournalDetailDataSource(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError>
    
    func makeJournalData(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError>
    
    func getAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError>
    
    func deleteJournalData(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError>
    
    func makeDiagData(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError>
    
    func updateNaverData(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError>
    
    func getDiagResultData(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError>
}
