//
//  JournalUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import Combine
import CombineMoya
import Moya
import SwiftUI

class JournalUseCase: JournalUseCaseProtocol {
    private let journalRepository: JournalRepositoryProtocol
    
    init(journalRepository: JournalRepositoryProtocol = JournalRepository()) {
        self.journalRepository = journalRepository
    }
    
    func executeGetJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError> {
        return journalRepository.getJournalList(petId: petId, category: category, page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetJournalDetailData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError> {
        return journalRepository.getJournalDetailData(petId: petId, recordId: recordId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeMakeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int : [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError> {
        return journalRepository.makeJournal(category: category, data: data, questionImage: questionImage)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError> {
        return journalRepository.getAnswerList(category: category)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeDeleteJournal(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError> {
        return journalRepository.deleteJournal(recordId: recordId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeMakeDiag(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError> {
        return journalRepository.makeDiag(data: data)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeUpdateNaver(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError> {
        return journalRepository.updateNaver(data: data)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeGetDiagResult(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError> {
        return journalRepository.getDiagResult(diagId: diagId)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
