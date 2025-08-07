//
//  PetProfileRepository.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import CombineMoya
import Combine
import Moya
import SwiftUI

protocol SearchRepositoryProtocol {
    func searchNaver(keyword: String) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
    func searchLocalDB(keyword: String, page: Int) -> AnyPublisher<ResponseData<[ProductResponse]>, MoyaError>
}
