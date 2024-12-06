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
}
