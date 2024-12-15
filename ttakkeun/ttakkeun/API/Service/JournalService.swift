//
//  JournalService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class JournalService: JournalServiceProtocol {
    private let provider: MoyaProvider<JournalAPITarget>
    
    init(provider: MoyaProvider<JournalAPITarget> = APIManager.shared.createProvider(for: JournalAPITarget.self)) {
        self.provider = provider
    }
    
    /* --- 일지 --- */
    
    func getJournalListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError> {
        return provider.requestPublisher(.getJournalList(petId: petId, category: category, page: page))
            .map(ResponseData<JournalListResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getJournalDetailDataSource(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError> {
        return provider.requestPublisher(.getDetailJournalData(petId: petId, recordId: recordId))
            .map(ResponseData<JournalResultResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func makeJournalData(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int : [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError> {
        return provider.requestPublisher(.makeJournal(category: category, data: data, questionImage: questionImage))
            .map(ResponseData<MakeJournalResultResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError> {
        return provider.requestPublisher(.getAnswerList(category: category))
            .map(ResponseData<JournalQuestionResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func deleteJournalData(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError> {
        return provider.requestPublisher(.deleteJournal(recordId: recordId))
            .map(ResponseData<DeleteJournal>.self)
            .eraseToAnyPublisher()
    }
    
    func searchGetJournalData(category: PartItem.RawValue, page: Int, date: String) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError> {
        return provider.requestPublisher(.searchGetJournal(category: category, page: page, date: date))
            .map(ResponseData<JournalListResponse>.self)
            .eraseToAnyPublisher()
    }
    
    /* --- 진단 --- */
    
    func makeDiagData(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError> {
        return provider.requestPublisher(.makeDiagnosis(data: data))
            .map(ResponseData<DiagResultResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func updateNaverData(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError> {
        return provider.requestPublisher(.updateNaverDiag(data: data))
            .map(ResponseData<UpdateNaverResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getDiagResultData(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError> {
        return provider.requestPublisher(.getDiagResult(diagId: diagId))
            .map(ResponseData<DiagnosticResolutionResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getDiagListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagResultListResponse>, MoyaError> {
        return provider.requestPublisher(.getDiagList(petId: petId, category: category, page: page))
            .map(ResponseData<DiagResultListResponse>.self)
            .eraseToAnyPublisher()
    }
    
    func getUserPointData() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError> {
        return provider.requestPublisher(.getUserPoint)
            .map(ResponseData<DiagUserPoint>.self)
            .eraseToAnyPublisher()
    }
    
    func patchUserPointData() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError> {
        return provider.requestPublisher(.patchUserPoint)
            .map(ResponseData<DiagUserPoint>.self)
            .eraseToAnyPublisher()
    }
}
