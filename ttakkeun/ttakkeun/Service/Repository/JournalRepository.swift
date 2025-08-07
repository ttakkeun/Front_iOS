//
//  JournalRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

class JournalRepository: JournalRepositoryProtocol {
    private let journalService: JournalServiceProtocol
    
    init(journalService: JournalServiceProtocol = JournalService()) {
        self.journalService = journalService
    }
    
    /* --- 일지 --- */
    
    func getJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError> {
        return journalService.getJournalListData(petId: petId, category: category, page: page)
    }
    
    func getJournalDetailData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError> {
        return journalService.getJournalDetailDataSource(petId: petId, recordId: recordId)
    }
    
    func makeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int : [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError> {
        return journalService.makeJournalData(category: category, data: data, questionImage: questionImage)
    }
    
    func getAnswerList(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError> {
        return journalService.getAnswerListData(category: category)
    }
    
    func deleteJournal(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError> {
        return journalService.deleteJournalData(recordId: recordId)
    }
    
    func searchGetJournal(category: PartItem.RawValue, date: String) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError> {
        return journalService.searchGetJournalData(category: category, date: date)
    }
    
    /* --- 진단 --- */
    
    func makeDiag(data: CreateDiagRequst) -> AnyPublisher<ResponseData<DiagResultResponse>, MoyaError> {
        return journalService.makeDiagData(data: data)
    }
    
    func updateNaver(data: DiagResultResponse) -> AnyPublisher<ResponseData<UpdateNaverResponse>, MoyaError> {
        return journalService.updateNaverData(data: data)
    }
    
    func getDiagResult(diagId: Int) -> AnyPublisher<ResponseData<DiagnosticResolutionResponse>, MoyaError> {
        return journalService.getDiagResultData(diagId: diagId)
    }
    
    func getDiagList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<DiagResultListResponse>, MoyaError> {
        return journalService.getDiagListData(petId: petId, category: category, page: page)
    }
    
    func getUserPoint() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError> {
        return journalService.getUserPointData()
    }
    
    func patchUserPoint() -> AnyPublisher<ResponseData<DiagUserPoint>, MoyaError> {
        return journalService.patchUserPointData()
    }
}
