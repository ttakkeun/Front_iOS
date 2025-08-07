//
//  SearchService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/10/24.
//

import Foundation
import Moya
import Combine
import CombineMoya
import SwiftUI

class SearchService: SearchServiceProtocol {
    
    private let provider: MoyaProvider<SearchAPITarget>
    
    init(provider: MoyaProvider<SearchAPITarget> = APIManager.shared.createProvider(for: SearchAPITarget.self)) {
        self.provider = provider
    }
    
    func searchNaverData(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return provider.requestPublisher(.searchNaverProduct(keyword: keyword))
            .map(ResponseData<[ProductResponse]>.self)
            .eraseToAnyPublisher()
    }
    
    func searchLocalDBData(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError> {
        return provider.requestPublisher(.searchLocalDBProduct(keyword: keyword, page: page))
            .map(ResponseData<[ProductResponse]>.self)
            .eraseToAnyPublisher()
    }
}
