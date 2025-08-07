//
//  SearchRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/10/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class SearchRepository: SearchRepositoryProtocol {
    
    private let searchService: SearchServiceProtocol
    
    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }
    
    func searchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return searchService.searchNaverData(keyword: keyword)
    }
    
    func searchLocalDB(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return searchService.searchLocalDBData(keyword: keyword, page: page)
    }
}
