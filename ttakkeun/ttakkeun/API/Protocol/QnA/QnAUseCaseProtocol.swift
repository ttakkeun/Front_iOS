//
//  PetProfileUseCase.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/5/24.
//

import Foundation
import Combine
import CombineMoya
import Moya
import SwiftUI

protocol QnAUseCaseProtocol {
    func executeGetTipsAll(page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func executeGetTipsBest() -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
    func executeGetTips(cateogry: PartItem.RawValue, page: Int) -> AnyPublisher<ResponseData<[TipsResponse]>, MoyaError>
}
