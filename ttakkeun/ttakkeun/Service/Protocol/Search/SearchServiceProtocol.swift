//
//  PetProfileService.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Foundation
import Combine
import Moya

protocol SearchServiceProtocol {
    func searchNaverData(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func searchLocalDBData(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
