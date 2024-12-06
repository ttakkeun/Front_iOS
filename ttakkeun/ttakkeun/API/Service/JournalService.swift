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
}
