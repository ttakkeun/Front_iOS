//
//  SearchUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/10/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class SearchUseCase: SearchUseCaseProtocol {
    
    private let searchRepository: SearchRepositoryProtocol
    
    init(searchRepository: SearchRepositoryProtocol = SearchRepository()) {
        self.searchRepository = searchRepository
    }
    
    func executeSearchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return searchRepository.searchNaver(keyword: keyword)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
    
    func executeSearchLocalDB(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return searchRepository.searchLocalDB(keyword: keyword, page: page)
            .mapError { $0 as MoyaError }
            .eraseToAnyPublisher()
    }
}
