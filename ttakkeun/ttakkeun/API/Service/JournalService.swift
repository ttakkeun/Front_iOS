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
}
