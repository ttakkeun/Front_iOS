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
    func getJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError>
    
    func getJournalDetailData(petId: Int, recordId: Int) -> AnyPublisher<ResponseData<JournalResultResponse>, MoyaError>
    
    func makeJournal(category: PartItem.RawValue, data: SelectedAnswerRequest, questionImage: [Int: [UIImage]]) -> AnyPublisher<ResponseData<MakeJournalResultResponse>, MoyaError>
    
    func getAnswerList(category: PartItem.RawValue) -> AnyPublisher<ResponseData<JournalQuestionResponse>, MoyaError>
    
    func deleteJournal(recordId: Int) -> AnyPublisher<ResponseData<DeleteJournal>, MoyaError>
}
