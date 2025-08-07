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
    
    /* --- 일지 --- */
    
    func getJournalListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    
    func getJournalDetailDataSource(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError>
    
    func makeJournalData(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError>
    
    func getAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError>
    
    func deleteJournalData(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError>
    
    func searchGetJournalData(category: PartItem.RawValue, date: String) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    
    /* --- 진단 --- */
    
    func makeDiagData(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError>
    
    func updateNaverData(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError>
    
    func getDiagResultData(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError>
    
    func getDiagListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagResultListResponse>, MoyaError>
    
    func getUserPointData() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError>
    
    func patchUserPointData() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError>
}
