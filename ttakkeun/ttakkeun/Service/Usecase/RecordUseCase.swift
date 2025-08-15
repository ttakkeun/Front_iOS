//
//  RecordUseCase.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Combine
import CombineMoya
import Moya

class RecordUseCase: RecordUseCaseProtocol {
    private let service: RecordServiceProtocol
    
    init(service: RecordServiceProtocol = RecordService()) {
        self.service = service
    }
    
    /// 일지 생성
    func executePostGenerateJournal(petId: Int, category: PartItem.RawValue, data: RecordGenerateRequest, questionImage: [Int : [Data]]) -> AnyPublisher<ResponseData<RecordGenerateResponse>, Moya.MoyaError> {
        return service.postGenerateJournalData(petId: petId, category: category, data: data, questionImage: questionImage)
    }
    
    /// 일지 목록 조회
    func executeGetJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<RecordListResponse>, Moya.MoyaError> {
        return service.getJournalListData(petId: petId, category: category, page: page)
    }
    
    /// 일지 기록 검색
    func executeGetSearchJournal(petId: Int, category: PartItem.RawValue, date: String) -> AnyPublisher<ResponseData<RecordListResponse>, Moya.MoyaError> {
        return service.getSearchJournalData(petId: petId, category: category, date: date)
    }
    
    /// 일지 질뭍 및 답변 조회
    func executeGetAnswerList(category: PartItem.RawValue) -> AnyPublisher<ResponseData<RecordQuestionResponse>, Moya.MoyaError> {
        return service.getAnswerListData(category: category)
    }
    
    /// 일지 상세 내용 조회
    func executeGetDetailJournal(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<RecordResultResponse>, Moya.MoyaError> {
        return service.getDetailJournalData(petId: petId, recordId: recordId)
    }
    
    /// 일지 삭제
    func executeDeleteJournal(recordId: Int) -> AnyPublisher<ResponseData<RecordDeleteResponse>, Moya.MoyaError> {
        return service.deleteJournalData(recordId: recordId)
    }
}
