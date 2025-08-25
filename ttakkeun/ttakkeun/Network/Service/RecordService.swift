//
//  RecordService.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/15/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

class RecordService: RecordServiceProtocol, BaseAPIService {
    typealias Target = RecordRouter
    
    let provider: MoyaProvider<RecordRouter>
    let decoder: JSONDecoder
    let callbackQueue: DispatchQueue
    
    init(
        provider: MoyaProvider<RecordRouter> = APIManager.shared.createProvider(for: RecordRouter.self),
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = provider
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func postGenerateJournalData(petId: Int, category: PartItem.RawValue, data: RecordGenerateRequest, questionImage: [Int : [Data]]) -> AnyPublisher<ResponseData<RecordGenerateResponse>, Moya.MoyaError> {
        request(.postGenerateJournal(petId: petId, category: category, data: data, questionImage: questionImage))
    }
    
    func getJournalListData(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<RecordListResponse>, Moya.MoyaError> {
        request(.getJournalList(petId: petId, category: category, page: page))
    }
    
    func getSearchJournalData(petId: Int, category: PartItem.RawValue, date: String) -> AnyPublisher<ResponseData<RecordListResponse>, Moya.MoyaError> {
        request(.getSearchJournal(petId: petId, category: category, date: date))
    }
    
    func getAnswerListData(category: PartItem.RawValue) -> AnyPublisher<ResponseData<RecordQuestionResponse>, Moya.MoyaError> {
        request(.getAnswerList(category: category))
    }
    
    func getDetailJournalData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<RecordResultResponse>, Moya.MoyaError> {
        request(.getDetailJournalData(petId: petId, recordId: recordId))
    }
    
    func deleteJournalData(recordId: Int) -> AnyPublisher<ResponseData<RecordDeleteResponse>, Moya.MoyaError> {
        request(.deleteJournal(recordId: recordId))
    }
}
