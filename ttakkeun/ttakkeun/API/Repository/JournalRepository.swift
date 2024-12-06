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
    
    func getJournalList(petId: Int, category: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<JournalListResponse>, MoyaError> {
        return journalService.getJournalListData(petId: petId, category: category, page: page)
    }
}
