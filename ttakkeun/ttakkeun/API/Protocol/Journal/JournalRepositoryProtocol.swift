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

protocol JournalRepositoryProtocol {
    
    /* --- 일지 --- */
    
    func getJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    
    func getJournalDetailData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError>
    
    func makeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError>
    
    func getAnswerList(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError>
    
    func deleteJournal(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError>
    
    func searchGetJournal(category: PartItem.RawValue, page: Int, date: String) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    
    /* --- 진단 --- */
    
    func makeDiag(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError>
    
    func updateNaver(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError>
    
    func getDiagResult(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError>
    
    func getDiagList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagResultListResponse>, MoyaError>
    
    func getUserPoint() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError>
    
    func patchUserPoint() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError>
}
