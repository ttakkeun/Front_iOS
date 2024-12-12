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
import SwiftUI

protocol QnAServiceProtocol {
    func getTipsAllData(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func getTipsBestData() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func getTipsPart(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
}
